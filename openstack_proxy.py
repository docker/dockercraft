import sys
import copy
import novaclient.client
import novaclient.shell
import novaclient.exceptions
import json
import urllib2
import uuid
import threading
import time
from flask import Flask, jsonify, request, url_for, abort, Response


app = Flask(__name__)


def _get_novaclient():
    nova_shell = novaclient.shell.OpenStackComputeShell()
    parser = nova_shell.get_base_parser()
    (config, _) = parser.parse_known_args(sys.argv)

    nc = novaclient.client.Client('2',
                                  config.os_username,
                                  config.os_password,
                                  config.os_tenant_name,
                                  config.os_auth_url)
    return nc


nova_client = None


def get_novaclient():
    global nova_client
    if nova_client:
        return nova_client
    nova_client = _get_novaclient()
    return nova_client


def _get_servers(id_or_name=None):
    if not id_or_name:
        return [x for x in get_novaclient().servers.list()]
    try:
        server = get_novaclient().servers.get(id_or_name)
        return [server]
    except novaclient.exceptions.NotFound:
        return [x for x in get_novaclient().servers.list()
                if x.name == id_or_name]


def _get_images(id_or_name):
    try:
        image = get_novaclient().images.get(id_or_name)
        return [image]
    except novaclient.exceptions.NotFound:
        return [x for x in get_novaclient().images.list()
                if x.name == id_or_name]


def _get_flavors(id_or_name):
    try:
        flavor = get_novaclient().flavors.get(id_or_name)
        return [flavor]
    except novaclient.exceptions.NotFound:
        return [x for x in get_novaclient().flavors.list()
                if x.name == id_or_name]


class MissingImage(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)


class MissingFlavor(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)


class MissingServer(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)


def _create_server(name, image, flavor):
    images = _get_images(image)
    if not images:
        raise MissingImage(image)

    flavors = _get_flavors(flavor)
    if not flavors:
        raise MissingFlavor(flavor)

    server = get_novaclient().servers.create(name, images[0].id, flavors[0].id)
    return server


def _delete_server(id_or_name):
    servers = _get_servers(id_or_name)
    if not servers:
        raise MissingServer(id_or_name)
    get_novaclient().servers.delete(servers[0].id)
    return servers[0].id


def _stop_server(id_or_name):
    servers = _get_servers(id_or_name)
    if not servers:
        raise MissingServer(id_or_name)
    get_novaclient().servers.stop(servers[0].id)


def _start_server(id_or_name):
    servers = _get_servers(id_or_name)
    if not servers:
        raise MissingServer(id_or_name)
    get_novaclient().servers.start(servers[0].id)


@app.route('/nova/server/<server>', methods=['GET'])
def get_server(server):
    servers = _get_servers(server)
    if servers:
        response = jsonify(servers[0].to_dict())
        response.status_code = 200
        return response
    response = Response()
    response.status_code = 404
    return response


@app.route('/nova/servers', methods=['GET'])
def get_servers():
    response = jsonify(server=[x.to_dict() for x in _get_servers()])
    response.status_code = 200
    return response


@app.route('/nova/servers', methods=['POST'])
def create_server():
    req = request.json
    response = jsonify(_create_server(req['name'],
                                      req['image'],
                                      req['flavor']).to_dict())
    response.code = 200
    return response


@app.route('/nova/server/<server>', methods=['DELETE'])
def delete_server(server):
    response = jsonify({'id': _delete_server(server)})
    response.code = 200
    return response


@app.route('/nova/server/<server>/action/stop', methods=['PUT'])
def stop_server(server):
    response = Response()
    _stop_server(server)
    response.code = 200
    return response


@app.route('/nova/server/<server>/action/start', methods=['PUT'])
def start_server(server):
    response = Response()
    _start_server(server)
    response.code = 200
    return response


class Notification():
    # TODO: be thread safe
    notifications = {}
    state = {}

    def __init__(self):
        t = threading.Thread(target=self.poll)
        t.daemon = True
        t.start()

    def poll(self):
        while True:
            time.sleep(1)
            tasks = copy.copy(self.notifications)
            for task in tasks:
                try:
                    self.check_state(task)
                except Exception as e:
                    print e.message

    def add(self, notification_func, metric_func,
            comparator_func=lambda previous, current: previous != current):
        notify_id = uuid.uuid4()
        self.notifications[notify_id] = (metric_func,
                                         comparator_func,
                                         notification_func)
        self.check_state(notify_id)
        return notify_id

    def check_state(self, notify_id):
        m, c, n = self.notifications[notify_id]
        current_value = m()
        if notify_id in self.state:
            previous_value = self.state[notify_id]
            if c(previous_value, current_value):
                print 'notify'
                n(previous_value, current_value)
        self.state[notify_id] = current_value

    def delete(self, notify_id):
        notifications.pop(notify_id)
        state.pop(notify_id)

notification = Notification()


@app.route('/notifications/', methods=['POST'])
def add_notification():
    req = request.json
    notification_url = req['notificationUrl']
    monitor = req['monitor']
    response = Response()
    if monitor == 'servers':
        notify_id = add_notification_on_servers(notification_url)
    if monitor == 'specifiedServer':
        server = req['server']
        notify_id = add_notification_on_server_status(notification_url, server)
    response = jsonify(notifyId=notify_id)
    response.code = 200
    return response


def add_notification_on_servers(notification_url):
    def evaluate_metric():
        servers = _get_servers()
        #return set([server.to_dict() for server in servers])
        return {server.id: server for server in servers}

    def notify_func(previous, current):
        increase_servers = set(current) - set(previous)
        decrease_servers = set(previous) - set(current)
        data = {'monitor': 'servers',
                'increaseServers': [current[x].to_dict()
                                    for x in increase_servers],
                'decreaseServers': [previous[x].to_dict()
                                    for x in decrease_servers],
                }
        notify_cuberite_callback(notification_url, data)

    notify_id = notification.add(notify_func, evaluate_metric)
    return notify_id


def add_notification_on_server_status(notification_url, server):
    server_obj = _get_servers(server)[0]

    def evaluate_metric():
        servers = _get_servers(server)
        if not servers:
            return None, "GONE"
        return servers[0].status

    def notify_func(previous_metric, current):
        data = {'monitor': 'specifiedServer',
                'server': server_obj.to_dict(),
                'status': current}
        notify_cuberite_callback(notification_url, data)

    notify_id = notification.add(notify_func, evaluate_metric)
    return notify_id


def notify_cuberite_callback(notification_url, data):
    req = urllib2.Request(notification_url)
    req.add_header('Content-Type', 'application/json')
    data_str = json.dumps(data)
    try:
        urllib2.urlopen(req, data_str)
    except:
        # FIXME: cuberite openstack plugin responds illegal status.
        pass


if __name__ == '__main__':
    app.run(port=8000, debug=True)

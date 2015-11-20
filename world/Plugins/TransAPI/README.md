TransAPI
========

A plugin translation API for Cuberite.

TransAPI is designed to be used with the [client library](https://github.com/cuberite/transapi-client), however there is also a stable API available for use.

API
---

    GetLanguage(cPlayer)
    Returns the user's preferred language (or server default if not set). (ISO 639-1 language code)

    GetConsoleLanguage()
    Returns the preferred language for console text. (ISO 639-1 language code)

Commands
--------

 * /language [lang] - Takes a language code (ISO 639-1) and sets the user's preferred language to that.

Permissions
-----------

 * _transapi.setlang_ - Allows use of the /language command.

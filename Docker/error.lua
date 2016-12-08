-- NewError returns an error object.
-- An error has a code and a message
function NewError(code, message)
	err = {code=code, message=message}
	return err
end
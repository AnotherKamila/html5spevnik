# a test metadata (sub)component

S.register 'Metadata.Test', (hooks) ->

    name = 'test'
    friendlyName = 'Test Metadata'

    # all metadata need to add their fields if they want to use them
    hooks['DB.beforeSetup'] = (data) ->
        data.addIndexField name

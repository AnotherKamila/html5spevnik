# a test file to see if `Metadata` does what it should (so far)

S.Metadata.register
    name: 'test'
    friendlyName: 'Test Metadata'
    # TODO write a encodeHtmlEntities function
    toHTML: (value) -> return value
    priority: 47

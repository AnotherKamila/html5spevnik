module 'BasicMetadata', 'contains defs for title, artist and tags', ->
    S.Metadata ?= {}
    # TODO maju si nejakym sposobom vediet urobit styles, chce to byt inde ako v elemente

    S.Metadata.title =
        name: 'Title'
        tohtml: (s) -> new Element 'span.metadata-basic',
            text: htmlescape s

    S.Metadata.artist =
        name: 'Artist'
        tohtml: (s) -> new Element 'span.metadata-basic',
            text: htmlescape s

    S.Metadata.tags =
        name: 'Tags'
        tohtml: (s) -> new Element 'span.metadata-multi'
            .adopt [ (new Element 'span.metadata-multi-item', text: htmlescape x.trim()) for x in s.split ';' ]

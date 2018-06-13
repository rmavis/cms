All Specs that have `field` methods (Compound fields and Pages) return hashes from that method in standard a form:
- The top-level keys are names that map to keys that can be used in the Content files. These are the "field handles" shared by the Spec and Content files.
- The values of those keys (in the Specs) are themselves hashes that describe the field's attributes. The second-level keys map to the field's classname (`:Image`, `:BodyBlocks`, etc), and the values under these keys contain hashes that describe that field's attributes.
- In the Content files, the values under the top-level keys contain the content to use for that field. The structure of this content must be in a form appropriate for that field.

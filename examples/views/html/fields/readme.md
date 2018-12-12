Subclasses of the Field class must specify three methods:
- view_file (void -> string)
  which names the field's view template file
- input_view_file (void -> string)
  which names the field's form field template file
- validate (a -> b|nil)
  which checks and validates the given value

Other methods from the base Field class should be re-implemented whenever it makes sense. When they do, the methods must have the appropriate type signatutes.

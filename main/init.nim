import jester, htmlgen

routes:
  get "/hello/@name":
    # This matches "/hello/fred" and "/hello/bob".
    # In the route ``@"name"`` will be either "fred" or "bob".
    # This can of course match any value which does not contain '/'.
    resp "Hello " & @"name"
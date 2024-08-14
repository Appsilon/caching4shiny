# Example from https://shiny.posit.co/r/articles/improve/caching/
RedisCache <- R6::R6Class("RedisCache",
  public = list(
    initialize = function(..., namespace = NULL) {
      private$r <- redux::hiredis(...)
      # Configure redis as a cache with a 800 MB capacity
      private$r$CONFIG_SET("maxmemory", "800mb")
      private$r$CONFIG_SET("maxmemory-policy", "allkeys-lru")
      private$namespace <- namespace
    },
    get = function(key) {
      key <- paste0(private$namespace, "-", key)
      s_value <- private$r$GET(key)
      if (is.null(s_value)) {
        return(structure(list(), class = "key_missing"))
      }
      unserialize(s_value)
    },
    set = function(key, value) {
      key <- paste0(private$namespace, "-", key)
      s_value <- serialize(value, NULL)
      private$r$SET(key, s_value)
    }
  ),
  private = list(
    r = NULL,
    namespace = NULL
  )
)

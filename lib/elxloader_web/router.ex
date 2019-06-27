defmodule ElxloaderWeb.Router do
  use ElxloaderWeb, :router

  alias GraphQL.ApiSchema

  forward "/api", Absinthe.Plug, schema: ApiSchema

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: ApiSchema,
    interface: :playground
end

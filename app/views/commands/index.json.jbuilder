json.array!(@commands) do |command|
  json.extract! command, :name, :type, :data, :module
  json.url command_url(command, format: :json)
end

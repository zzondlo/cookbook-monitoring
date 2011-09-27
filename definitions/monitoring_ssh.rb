define :monitoring_ssh do
  monitoring params[:name] do
    schedule params[:schedule] if params[:schedule]

    scheme "ssh://#{node.fqdn}" if not params[:scheme]
    scheme params[:scheme] if params[:scheme]

    # Handle command
    nagios_cmd "check_ssh"

    # Handle parameters
    parameters = []
    parameters << params[:nagios_parameters] if params[:nagios_parameters]
    parameters << "$HOSTADDRESS$" if not params[:nagios_parameters]
    nagios_parameters parameters

    # Handle externals
    external false
    external params[:external] if params[:external]

    external_only false
    external_only params[:external_only] if params[:external_only]

    external_uri "ssh://#{node.fqdn}"
    external_uri params[:scheme] if params[:scheme]
    external_uri params[:external_uri] if params[:external_uri]

    external_parameters params[:external_parameters] if params[:external_parameters]

    status true
    status params[:status] if params[:status]
  end
  
end

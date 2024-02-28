This is gem used for exchange data with horoshop.ua internet shop constructor

Authorization usage, at first you must create instance of class Horoshop with valid params to connect
After that you just use instance horoshop for all next requests.

    horoshop = Horoshop::Client.new(url: URI.parse('http://somesite.org'), username: 'jhon', password: 'piterson')
    
    Horoshop::Authotization.new(horoshop).authorize
    Horoshop::ImportResidues.new(horoshop).import(hash)

*ImportResidues* returns all log data without OK status.

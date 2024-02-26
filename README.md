This is gem used for exchange data with horoshop.ua internet shop constructor

Authorization usage, at first you must create instance of class Horoshop with valid params to connect

    horoshop = Horoshop::Client.new(url: 'http://somesite.org', username: 'jhon', password: 'piterson')
    Horoshop::Authotization.new(horoshop).authorize

After that you just use instance horoshop for all next requests.

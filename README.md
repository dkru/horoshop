This is gem used for exchange data with horoshop.ua internet shop constructor

##Basic usage

    auth_instance = Horoshop.new(url: 'http://somesite.org', username: 'jhon', password: 'piterson')


After that, you shuod just add variable auth to all you request.

    Horoshop::SendBalances.post(auth: auth, data: SOME_LONG_JSON_DATA)

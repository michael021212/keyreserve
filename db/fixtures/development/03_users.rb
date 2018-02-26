User.seed(
  :id,
  id: 1,
  email: 'corporation1@key-reserve.com',
  name: '企業ユーザー1',
  tel: '0312345678',
  salt: 'DYpi7ASX-Vnk4bTtye2x',
  crypted_password: Sorcery::CryptoProviders::BCrypt.encrypt(
    '1234', 'DYpi7ASX-Vnk4bTtye2x')
)

User.seed(
  :id,
  id: 2,
  email: 'user1@key-reserve.com',
  name: 'ユーザー1',
  tel: ' 0368693804 ',
  salt: 'ygH4d2wsh5DJx4rL8Jg6',
  crypted_password: Sorcery::CryptoProviders::BCrypt.encrypt(
    '1234', 'ygH4d2wsh5DJx4rL8Jg6')
)

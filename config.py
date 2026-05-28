class Config:
    SECRET_KEY= "waesrdfgvhbuydutrxasdfghyoeyfde8sdf"
    DEBUG = True

class DevelopmentConfig(Config):
    MYSQL_HOST = 'Localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'mysql'
    MYSQL_DB = 'lexis_visum'

class MailConfig(Config):
    MAIL_SERVER = 'smtp.gmail.com'
    MAIL_PORT = 587
    MAIL_USE_SSL = False
    MAIL_USE_TLS = True
    MAIL_USERNAME = 'maria.mejia5125@alumnos.udg.mx'
    MAIL_PASSWORD = 'zaly udtj xnzd ckch'
    MAIL_DEFAULT_SENDER = 'maria.mejia5125@alumnos.udg.mx'
    MAIL_ASCII_ATTACHMENTS = True


config = {
    'development': DevelopmentConfig,
    'mail': MailConfig
}

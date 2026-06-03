import os


class Config:
    SECRET_KEY= "waesrdfgvhbuydutrxasdfghyoeyfde8sdf"
    DEBUG = True

class DevelopmentConfig(Config):
    '''
    MYSQL_HOST = 'Localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'mysql'
    MYSQL_DB = 'lexis_visum'
    '''
    MYSQL_HOST = os.environ.get('MYSQLHOST')
    MYSQL_USER = os.environ.get('MYSQLUSER')
    MYSQL_PASSWORD = os.environ.get('MYSQLPASSWORD')
    MYSQL_DB = os.environ.get('MYSQLDATABASE')
    MYSQL_PORT = int(os.environ.get('MYSQLPORT', 3306))

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

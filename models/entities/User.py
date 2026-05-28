from werkzeug.security import check_password_hash
from flask_login import UserMixin


class User(UserMixin):
    def __init__(self, id, nombre, correo, clave, perfil) -> None:      
        self.id        = id
        self.nombre    = nombre
        self.correo    = correo
        self.clave     = clave
        self.perfil    = perfil
   
    @classmethod
    def validar_clave(self, clave_cifrada, clave):
        return check_password_hash(clave_cifrada, clave)
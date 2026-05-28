from flask import Flask, jsonify, render_template, url_for, request, redirect, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
import pymysql
pymysql.install_as_MySQLdb()
from flask_mysqldb import MySQL
from config import config
from flask_login import current_user, login_user, logout_user, LoginManager, login_required
from models.ModelUser import ModelUser
from models.entities.User import User
from flask_mail import Mail, Message


lexisvisumApp = Flask(__name__)

lexisvisumApp.config.from_object(config['development'])
lexisvisumApp.config.from_object(config['mail'])

db = MySQL(lexisvisumApp)
adminUsuarios = LoginManager(lexisvisumApp)
mail = Mail(lexisvisumApp)

@adminUsuarios.user_loader
def cargadorUsuarios(id):
    return ModelUser.get_by_id(db, id)

@lexisvisumApp.route('/')
def home():
    return render_template('home.html')

# Ruta para mostrar la página de login/registro (GET)
@lexisvisumApp.route('/signin_signup')
def signin_signup():
    return render_template('signin_signup.html')


# Ruta para procesar el REGISTRO
@lexisvisumApp.route('/signup', methods=['POST'])
def signup():
    if request.method == 'POST':
        nombre = request.form['nombre']
        correo = request.form['correo']
        clave = request.form['clave']
        claveCifrada = generate_password_hash(clave)
        	
        
        regUsuario = db.connection.cursor()
        # Verificar si el correo ya existe
        regUsuario.execute("SELECT * FROM users WHERE email = %s", (correo,))
        existe = regUsuario.fetchone()
        
        if existe:
            flash('El correo ya está registrado', 'error')
            return redirect(url_for('signin_signup'))
        
        msg = Message(subject='Bienvenido a Lexis Visum', recipients=[correo])
        msg.html = render_template('mail.html', nombre=nombre)

        # Insertar nuevo usuario (por defecto perfil 'U' de usuario normal)
        regUsuario.execute(
            "INSERT INTO users (username, password, email, user_type) VALUES (%s, %s, %s, %s)", 
            (nombre, claveCifrada, correo, 'U')
        )
        db.connection.commit()
        regUsuario.close()
        mail.send(msg)
        
        flash('Registro exitoso. Por favor inicia sesión', 'success')
        return redirect(url_for('signin_signup'))

# Ruta para procesar el LOGIN
# Ruta para procesar el LOGIN
@lexisvisumApp.route('/signin', methods=['POST'])
def signin():
    if request.method == 'POST':
        correo = request.form['correo']
        clave = request.form['clave']
        
        # Buscar usuario por correo
        cur = db.connection.cursor()
        cur.execute("SELECT id, username, password, email, user_type FROM users WHERE email = %s", (correo,))
        user_data = cur.fetchone()
        cur.close()
        
        if user_data:
            # Verificar contraseña
            if check_password_hash(user_data[2], clave):
                usuario = User(user_data[0], user_data[1], user_data[2], user_data[3], user_data[4])
                login_user(usuario)
                
                # CORRECCIÓN: Usar redirect en lugar de render_template
                if usuario.perfil == 'A':
                    return redirect(url_for('admin'))
                else:
                    return redirect(url_for('user'))
            else:
                flash('Contraseña incorrecta', 'error')
                return redirect(url_for('signin_signup'))
        else:
            flash('Usuario inexistente', 'error')
            return redirect(url_for('signin_signup'))
# Rutas protegidas

@lexisvisumApp.route('/admin')
@login_required
def admin():
    selUsuario = db.connection.cursor()
    selUsuario.execute('SELECT * FROM users')
    U = selUsuario.fetchall()
    selUsuario.close()
    return render_template('admin.html', users=U)

@lexisvisumApp.route('/user')
@login_required
def user():
    try:
        cur = db.connection.cursor()
        # Productos
        cur.execute("SELECT * FROM products")
        productos = cur.fetchall()
        
        # Planes de suscripción
        cur.execute("SELECT * FROM subscription_plans")
        executive = cur.fetchall()
        cur.close()

        print(f"🔍 Productos encontrados en BD: {len(productos)}")
        for p in productos[:5]:
            print(f"   - {p[1]} | versión: {p[3]} | precio: {p[4]}")

        # Filtrar productos por versión
        essential = [p for p in productos if p[3] == 'Essential']
        kids      = [p for p in productos if p[3] == 'Kids']
        edu       = [p for p in productos if p[3] == 'Edu']
        pro       = [p for p in productos if p[3] == 'Pro']

        print(f"📊 Essential: {len(essential)}, Kids: {len(kids)}, Edu: {len(edu)}, Executive: {len(executive)}, Pro: {len(pro)}")

        return render_template('user.html',
                               essential=essential,
                               kids=kids,
                               edu=edu,
                               executive=executive,
                               pro=pro)
    except Exception as e:
        print(f"❌ ERROR en /user: {e}")
        flash('Error al cargar productos', 'error')
        return render_template('user.html', essential=[], kids=[], edu=[], executive=[], pro=[])
def buscar():
    try:
        if method == 'POST':
            cur = db.connection.cursor()
            cur.execute("SELECT * FROM products WHERE name LIKE %s", ('%' + request.form['search'] + '%',))
            productos = cur.fetchall()
            cur.close()

            essential = [p for p in productos if p[2].strip() == 'Essential']
            kids      = [p for p in productos if p[2].strip() == 'Kids']
            edu       = [p for p in productos if p[2].strip() == 'Edu']
            executive = [p for p in productos if p[2].strip() == 'Executive']
            pro       = [p for p in productos if p[2].strip() == 'Pro']

            return render_template('user.html',
                                   essential=essential,
                                   kids=kids,
                                   edu=edu,
                                   executive=executive,
                                   pro=pro)
    except Exception as e:
        print(f"❌ ERROR en /buscar: {e}")
        flash('Error al buscar productos', 'error')
        return render_template('user.html', essential=[], kids=[], edu=[], executive=[], pro=[])
    
@lexisvisumApp.route('/cart', methods=['POST'])
@login_required
def añadir_al_carrito():
    try:
        product_id = request.form['product_id']
        cur = db.connection.cursor()

        # Buscar o crear el carrito del usuario
        cur.execute("SELECT id FROM carts WHERE user_id = %s", (current_user.id,))
        cart = cur.fetchone()

        if cart:
            cart_id = cart[0]
        else:
            cur.execute("INSERT INTO carts (user_id) VALUES (%s)", (current_user.id,))
            db.connection.commit()
            cart_id = cur.lastrowid

        # Verificar si el producto ya está en cart_items
        cur.execute("SELECT id, quantity FROM cart_items WHERE cart_id = %s AND product_id = %s",
                    (cart_id, product_id))
        existing = cur.fetchone()

        if existing:
            cur.execute("UPDATE cart_items SET quantity = quantity + 1 WHERE id = %s",
                        (existing[0],))
        else:
            cur.execute("INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (%s, %s, 1)",
                        (cart_id, product_id))

        db.connection.commit()
        cur.close()

        flash('Producto añadido al carrito', 'success')

    except Exception as e:
        print(f"❌ ERROR al añadir al carrito: {e}")
        flash('Error al añadir producto', 'error')

@lexisvisumApp.route('/cart/count')
@login_required
def cart_count():
    try:
        cur = db.connection.cursor()
        cur.execute("SELECT SUM(quantity) FROM cart WHERE user_id = %s", (current_user.id,))
        result = cur.fetchone()
        cur.close()
        total = int(result[0]) if result[0] else 0
        return jsonify({'count': total})
    except Exception as e:
        return jsonify({'count': 0})


@lexisvisumApp.route('/home')
def productos():
    try:
        cur = db.connection.cursor()
        cur.execute('SELECT * FROM products')
        all_products = cur.fetchall()
        cur.close()

        # Imprime las primeras filas para ver exactamente qué trae
        for p in all_products[:3]:
            print("Fila:", p)
            print("version raw:", repr(p[2]))  # repr muestra espacios ocultos

        essential  = [p for p in all_products if p[2].strip() == 'Essential']
        kids       = [p for p in all_products if p[2].strip() == 'Kids']
        edu        = [p for p in all_products if p[2].strip() == 'Edu']
        executive  = [p for p in all_products if p[2].strip() == 'Executive']
        pro        = [p for p in all_products if p[2].strip() == 'Pro']

        return render_template('user.html',
            essential=essential,
            kids=kids,
            edu=edu,
            executive=executive,
            pro=pro
        )
    except Exception as e:
        print("ERROR:", e)
        return str(e), 500


#@lexisvisumApp.route('/users')
#@login_required
#def user():
 #   return render_template('user.html')

@lexisvisumApp.route('/signout')
@login_required
def signout():
    logout_user()
    flash('Has cerrado sesión correctamente', 'success')
    return redirect(url_for('home'))

#@lexisvisumApp.route('/sUsuarios')
#@login_required

#def sUsuario():
    #selUsuario = db.connection.cursor()
    #selUsuario.execute('SELECT * FROM users')
    #U = selUsuario.fetchall()
    #selUsuario.close()
    #return render_template('admin.html', users = U)

@lexisvisumApp.route('/iUsuario', methods=['GET', 'POST'])
@login_required
def iUsuario():
    if request.method == 'POST':
        nombre = request.form['nombre']
        correo = request.form['correo']
        clave = request.form['clave']
        claveCifrada = generate_password_hash(clave)
        perfil = request.form['perfil']
        

        regUsuario = db.connection.cursor()
        regUsuario.execute(
            "INSERT INTO users(username, password, email, user_type) VALUES (%s, %s, %s, %s)",
            (nombre, claveCifrada, correo, perfil)
        )
        db.connection.commit()
        regUsuario.close()
        
        flash('Usuario creado correctamente', 'success')
        return redirect(url_for('admin'))
    
    return render_template('iUsuario.html')


@lexisvisumApp.route('/home_user', methods=['GET','POST'])
def homeuser():
    selC

@lexisvisumApp.route('/SCarrito',  methods=['GET', 'POST'])
def sCarrito():
    selCarrito= db.connection.cursor()
    selCarrito.execute("SELECT * FROM CART")
    c = selCarrito.fetchall()
    selCarrito.close()
    return render_template('usuario.html', carrito = c)

lexisvisumApp.route('/iCarrito', methods=['GET','POST'])
def iCarrito(id):
    selCarrito = db.connection.cursor()
    selCarrito.execute("SELECT * FROM carrito WHERE id=%s",(id,))
    c = selCarrito.fetchone()
    if not c:
        flash('Producto no encontrado en el carrito')
        return redirect(url_for('sCarrito'))
    producto ={
        'id'[0],
        'nombre'[1],
        'descripcion'[2],
        'version'[3],
        'categoria'[4],
        'precio'[5]


    }    
    if "carrito" not in session:
        session['carrito'] = []
    session['carrito'].append(producto)
    flash('Producto agregado al carrito')
    return redirect(url_for('sCarrito'))



# Configuración secreta para flash messages
lexisvisumApp.config['SECRET_KEY'] = 'tu_clave_secreta_aqui'

if __name__ == '__main__':
    lexisvisumApp.run(port=5500, debug=True)
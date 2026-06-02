from flask import Flask, jsonify, render_template, url_for, request, redirect, flash, session
from werkzeug.security import generate_password_hash, check_password_hash
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

@lexisvisumApp.route('/signin_signup')
def signin_signup():
    return render_template('signin_signup.html')

@lexisvisumApp.route('/signup', methods=['POST'])
def signup():
    nombre = request.form['nombre']
    correo = request.form['correo']
    clave  = request.form['clave']
    claveCifrada = generate_password_hash(clave)

    cur = db.connection.cursor()
    cur.execute("SELECT * FROM users WHERE email = %s", (correo,))
    existe = cur.fetchone()

    if existe:
        flash('El correo ya está registrado', 'error')
        return redirect(url_for('signin_signup'))

    cur.execute("INSERT INTO users (username, password, email, user_type) VALUES (%s, %s, %s, %s)",
                (nombre, claveCifrada, correo, 'U'))
    db.connection.commit()
    cur.close()

    msg = Message(subject='Bienvenido a Lexis Visum', recipients=[correo])
    msg.html = render_template('mail.html', nombre=nombre)
    mail.send(msg)

    flash('Registro exitoso. Por favor inicia sesión', 'success')
    return redirect(url_for('signin_signup'))

@lexisvisumApp.route('/signin', methods=['POST'])
def signin():
    correo = request.form['correo']
    clave  = request.form['clave']

    cur = db.connection.cursor()
    cur.execute("SELECT id, username, password, email, user_type FROM users WHERE email = %s", (correo,))
    user_data = cur.fetchone()
    cur.close()

    if user_data and check_password_hash(user_data[2], clave):
        usuario = User(user_data[0], user_data[1], user_data[2], user_data[3], user_data[4])
        login_user(usuario)
        return redirect(url_for('admin') if usuario.perfil == 'A' else url_for('user'))

    flash('Credenciales incorrectas', 'error')
    return redirect(url_for('signin_signup'))


@lexisvisumApp.route('/admin')
@login_required
def admin():
    cur = db.connection.cursor()
    cur.execute('SELECT * FROM users')
    U = cur.fetchall()
    cur.close()

    editar_id = request.args.get('editar', type=int)
    user_editar = None

    if editar_id:
        cur = db.connection.cursor()
        cur.execute('SELECT * FROM users WHERE id = %s', (editar_id,))
        user_editar = cur.fetchone()
        cur.close()

    cur = db.connection.cursor()
    cur.execute('SELECT * FROM products')
    P = cur.fetchall()
    cur.close()

    return render_template('admin.html', users=U, user_editar=user_editar, products=P)

@lexisvisumApp.route('/eliminar_usuario/<int:id>', methods=['POST'])
@login_required
def eliminar_usuario(id):
    cursor = db.connection.cursor()
    cursor.execute("DELETE FROM users WHERE id=%s", (id,))
    db.connection.commit()
    cursor.close()

@lexisvisumApp.route('/editar_usuario/<int:id>', methods=['POST'])
@login_required
def editar_usuario(id):
    nombre = request.form['nombre']
    correo = request.form['correo']
    clave  = request.form['clave']
    perfil = request.form['perfil']

    cur = db.connection.cursor()
    if clave.strip():
        claveCifrada = generate_password_hash(clave)
        cur.execute("UPDATE users SET username=%s, email=%s, password=%s, user_type=%s WHERE id=%s",
                    (nombre, correo, claveCifrada, perfil, id))
    else:
        cur.execute("UPDATE users SET username=%s, email=%s, user_type=%s WHERE id=%s",
                    (nombre, correo, perfil, id))

    db.connection.commit()
    cur.close()
    flash('Usuario actualizado correctamente', 'success')
    return redirect(url_for('admin'))

@lexisvisumApp.route('/editar_producto/<int:id>', methods=['POST'])
@login_required
def editar_producto(id):
    nombre      = request.form['nombre']
    descripcion = request.form['descripcion']
    version     = request.form['version']
    categoria   = request.form['categoria']
    inventario  = request.form['inventario']
    precio      = request.form['precio']
    imagen      = request.form['imagen']

    cur = db.connection.cursor()
    cur.execute("""
        UPDATE products
        SET name=%s, description=%s, version=%s, category_id=%s,
            inventory=%s, price=%s, Image=%s
        WHERE id=%s
    """, (nombre, descripcion, version, categoria, inventario, precio, imagen, id))
    db.connection.commit()
    cur.close()

    flash('Producto actualizado correctamente', 'success')
    return redirect(url_for('admin'))

@lexisvisumApp.route('/eliminar_producto/<int:id>', methods=['POST'])
@login_required
def eliminar_producto(id):
    cursor = db.connection.cursor()
    cursor.execute("DELETE FROM products WHERE id=%s", (id,))
    db.connection.commit()
    cursor.close()

@lexisvisumApp.route('/user')
@login_required
def user():
    try:
        cur = db.connection.cursor()

        # p[0]=id, p[1]=name, p[2]=description, p[3]=version
        # p[4]=category_id, p[5]=inventory, p[6]=price, p[7]=Image
        cur.execute("SELECT * FROM products")
        productos = cur.fetchall()

        cur.execute("SELECT * FROM subscription_plans")
        executive = cur.fetchall()
        cur.close()

        essential = [p for p in productos if p[3] == 'Essential']
        kids      = [p for p in productos if p[3] == 'Kids']
        edu       = [p for p in productos if p[3] == 'Edu']
        pro       = [p for p in productos if p[3] == 'Pro']

        cur = db.connection.cursor()
        cur.execute ("""
            SELECT
                *
            FROM user_product
            WHERE user_id = %s
            ORDER BY purchase_date
        """, (current_user.id,))

        rows = cur.fetchall()
        cur.close()

        productos = []
        for r in rows:
            productos.append({
                'id'          : r[0],
                'user_id'     : r[1],
                'product_id'  : r[2],
                'serial_number' : r[3],
                'purchase_date' : r[4],
                'warranty_end' : r[5],
                'status' : r[6]
            })
        
        cur = db.connection.cursor()

        # Un solo query con JOIN para traer todo
        cur.execute("""
            SELECT 
                ci.id,
                ci.product_id,
                ci.quantity,
                p.name,
                p.price,
                p.Image
            FROM cart_items ci
            JOIN carts c ON ci.cart_id = c.id
            JOIN products p ON ci.product_id = p.id
            WHERE c.user_id = %s
        """, (current_user.id,))

        rows = cur.fetchall()
        cur.close()

        items = []
        total = 0
        for r in rows:
            subtotal = r[2] * float(r[4])
            total += subtotal
            items.append({
                'item_id'   : r[0],
                'product_id': r[1],
                'quantity'  : r[2],
                'name'      : r[3],
                'price'     : float(r[4]),
                'image'     : r[5],
                'subtotal'  : subtotal
            })
            
        return render_template('user.html',
                               essential=essential,
                               kids=kids,
                               edu=edu,
                               executive=executive,
                               pro=pro,
                               rows=productos,
                               items=items, 
                               total=total)
    except Exception as e:
        print(f"❌ ERROR en /user: {e}")
        return render_template('user.html', essential=[], kids=[], edu=[], executive=[], pro=[],rows=[])

@lexisvisumApp.route('/cart/add/<int:product_id>', methods=['POST'])
@login_required
def añadir_al_carrito(product_id):
    try:
        cur = db.connection.cursor()

        cur.execute("SELECT id FROM carts WHERE user_id = %s", (current_user.id,))
        cart = cur.fetchone()

        if cart:
            cart_id = cart[0]
        else:
            cur.execute("INSERT INTO carts (user_id) VALUES (%s)", (current_user.id,))
            db.connection.commit()
            cart_id = cur.lastrowid

        cur.execute("SELECT id FROM cart_items WHERE cart_id = %s AND product_id = %s",
                    (cart_id, product_id))
        existing = cur.fetchone()

        if existing:
            cur.execute("UPDATE cart_items SET quantity = quantity + 1 WHERE id = %s", (existing[0],))
            flash('Cantidad actualizada', 'success')
        else:
            cur.execute("INSERT INTO cart_items (cart_id, product_id, plan_id, quantity) VALUES (%s, %s, NULL, 1)",
                        (cart_id, product_id))
            flash('Producto añadido al carrito', 'success')

        db.connection.commit()
        cur.close()
        return redirect(url_for('user'))

    except Exception as e:
        print(f"❌ ERROR al añadir al carrito: {e}")
        flash('Error al añadir producto', 'error')
        return redirect(url_for('user'))
    
@lexisvisumApp.route('/cart/add/plan/<int:plan_id>', methods=['POST'])
@login_required
def añadir_plan_al_carrito(plan_id):
    try:
        cur = db.connection.cursor()

        cur.execute("SELECT id FROM carts WHERE user_id = %s", (current_user.id,))
        cart = cur.fetchone()

        if cart:
            cart_id = cart[0]
        else:
            cur.execute("INSERT INTO carts (user_id) VALUES (%s)", (current_user.id,))
            db.connection.commit()
            cart_id = cur.lastrowid

        cur.execute("SELECT id FROM cart_items WHERE cart_id = %s AND plan_id = %s",
                    (cart_id, plan_id))
        existing = cur.fetchone()

        if existing:
            cur.execute("UPDATE cart_items SET quantity = quantity + 1 WHERE id = %s", (existing[0],))
            flash('Cantidad actualizada', 'success')
        else:
            # product_id va NULL porque es un plan, no un producto
            cur.execute("INSERT INTO cart_items (cart_id, product_id, plan_id, quantity) VALUES (%s, NULL, %s, 1)",
                        (cart_id, plan_id))
            flash('Plan añadido al carrito', 'success')

        db.connection.commit()
        cur.close()
        return redirect(url_for('user'))

    except Exception as e:
        print(f"❌ ERROR al añadir plan: {e}")
        flash('Error al añadir plan', 'error')
        return redirect(url_for('user'))
    
@lexisvisumApp.route('/add_user_product', methods=['POST'])
@login_required
def add_user_product():
    serial_number = request.form.get('serial_number', '').strip().upper()

    print("\n========== NUEVO REGISTRO ==========")
    print(f"Serial recibido: {serial_number}")

    if not serial_number:
        flash('Por favor ingresa un número de serie', 'error')
        return redirect(url_for('user'))

    # Formato esperado: LVPR-123-1-4567
    partes = serial_number.split('-')

    if len(partes) != 4:
        flash('Formato de número de serie inválido', 'error')
        return redirect(url_for('user'))

    prefijo = partes[0]
    id_str = partes[1]
    category_id_str = partes[2]
    aleatorio = partes[3]

    prefijos = {
        'LVKI': 'Kids',
        'LVES': 'Essential',
        'LVPR': 'Pro',
        'LVED': 'Edu'
    }

    print(f"Prefijo detectado: {prefijo}")
    print(f"ID producto extraído: {id_str}")
    print(f"Categoría extraída: {category_id_str}")
    print(f"Aleatorio: {aleatorio}")

    if prefijo not in prefijos:
        flash('Número de serie inválido: prefijo no reconocido', 'error')
        return redirect(url_for('user'))

    if not (
        id_str.isdigit() and
        category_id_str.isdigit() and
        aleatorio.isdigit()
    ):
        flash('Número de serie inválido: formato incorrecto', 'error')
        return redirect(url_for('user'))

    product_id = int(id_str)
    category_id = int(category_id_str)
    version_esperada = prefijos[prefijo]

    print(f"Product ID: {product_id}")
    print(f"Category ID: {category_id}")
    print(f"Versión esperada: {version_esperada}")

    cur = None

    try:
        cur = db.connection.cursor()

        print("Buscando producto...")

        cur.execute("""
            SELECT id, name, version, category_id
            FROM products
            WHERE id = %s
              AND category_id = %s
              AND version = %s
        """, (product_id, category_id, version_esperada))

        producto = cur.fetchone()

        print(f"Resultado producto: {producto}")

        if not producto:
            flash('Número de serie inválido: producto no encontrado', 'error')
            return redirect(url_for('user'))

        print("Verificando si el serial ya existe...")

        cur.execute("""
            SELECT id
            FROM user_product
            WHERE serial_number = %s
        """, (serial_number,))

        ya_registrado = cur.fetchone()

        print(f"Serial registrado previamente: {ya_registrado}")

        if ya_registrado:
            flash('Este número de serie ya está registrado', 'error')
            return redirect(url_for('user'))

        print("Verificando si el usuario ya tiene este producto...")

        cur.execute("""
            SELECT id
            FROM user_product
            WHERE user_id = %s
              AND product_id = %s
        """, (current_user.id, product_id))

        ya_tiene = cur.fetchone()

        print(f"Producto ya asociado al usuario: {ya_tiene}")

        if ya_tiene:
            flash('Ya tienes este producto registrado en tu cuenta', 'error')
            return redirect(url_for('user'))

        print("Insertando producto...")

        cur.execute("""
            INSERT INTO user_product
            (
                user_id,
                product_id,
                serial_number,
                purchase_date,
                warranty_end,
                status
            )
            VALUES
            (
                %s,
                %s,
                %s,
                NOW(),
                DATE_ADD(NOW(), INTERVAL 1 YEAR),
                'active'
            )
        """, (
            current_user.id,
            product_id,
            serial_number
        ))

        db.connection.commit()

        print("✅ PRODUCTO REGISTRADO CORRECTAMENTE")

        flash(
            f'Producto "{producto[1]}" registrado correctamente en tu cuenta',
            'success'
        )

        return redirect(url_for('user'))

    except Exception as e:
        print(f"❌ ERROR AL REGISTRAR PRODUCTO: {e}")
        db.connection.rollback()
        flash('Error al registrar el producto', 'error')
        return redirect(url_for('user'))

    finally:
        if cur:
            cur.close()



@lexisvisumApp.route('/iUsuario', methods=['GET', 'POST'])
@login_required
def iUsuario():
    if request.method == 'POST':
        nombre = request.form['nombre']
        correo = request.form['correo']
        clave  = request.form['clave']
        perfil = request.form['perfil']
        claveCifrada = generate_password_hash(clave)

        cur = db.connection.cursor()
        cur.execute("INSERT INTO users(username, password, email, user_type) VALUES (%s, %s, %s, %s)",
                    (nombre, claveCifrada, correo, perfil))
        db.connection.commit()
        cur.close()

        flash('Usuario creado correctamente', 'success')
        return redirect(url_for('admin'))

    return render_template('iUsuario.html')

@lexisvisumApp.route('/signout')
@login_required
def signout():
    logout_user()
    flash('Has cerrado sesión correctamente', 'success')
    return redirect(url_for('home'))

if __name__ == '__main__':
    lexisvisumApp.run(port=5500, debug=True)
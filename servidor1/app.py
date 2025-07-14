from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL
import os

app = Flask(__name__)

# Configuración de la base de datos MySQL
app.config['MYSQL_HOST'] = os.getenv("MYSQL_HOST", "maestro1")
app.config['MYSQL_USER'] = os.getenv("MYSQL_USER", "root")
app.config['MYSQL_PASSWORD'] = os.getenv("MYSQL_PASSWORD", "root")
app.config['MYSQL_DB'] = os.getenv("MYSQL_DB", "db_informacion")
app.config['MYSQL_PORT'] = int(os.getenv("MYSQL_PORT", 3306))

# Inicializar la base de datos
mysql = MySQL(app)

@app.route('/', methods=['GET', 'POST'])
def formulario():
    if request.method == 'POST':
        # Obtener datos del formulario
        nombre = request.form.get('nombre')
        correo = request.form.get('correo')
        experiencia = request.form.get('experiencia')
        formacion = request.form.get('formacion')
        # los datos, almacenarlos en una base de datos, etc.
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO datos (nombre,correo,experiencia,formacion) VALUES (%s, %s, %s,%s)", (nombre,correo,experiencia,formacion))
        mysql.connection.commit()
        cur.close()
                
        # Redirigir al formulario
        return redirect(url_for('formulario'))

    return render_template('index.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0')


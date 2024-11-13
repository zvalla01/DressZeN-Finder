from flask import Flask, render_template, request, redirect, url_for, flash, session, send_from_directory, logging
from flask_bcrypt import Bcrypt
import mysql.connector
from flask import Flask, render_template, request, jsonify


app = Flask(__name__)

app.secret_key = 'your_secret_key'  # Set a secret key for session management
app.config['MYSQL_HOST'] = "localhost"
app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = "new_password"

mysql_client = mysql.connector.connect(
    host="localhost",
    user="root",
    password="dress123",
    database="dresszenfinder5"
)

@app.route('/', methods=['GET', 'POST'])
def register():  # Changed function name from `index` to `register`
    if request.method == 'POST':
        username = request.form['username']
        size = request.form['size']
        age = request.form['age']
        email = request.form['email']
        gender = request.form['gender']
        password = request.form['password']

        cur = mysql_client.cursor()
        cur.execute("INSERT INTO users(username, size, age, email, gender, password) VALUES(%s, %s, %s, %s, %s, %s)", 
                    (username, size, age, email, gender, password))
        mysql_client.commit()
        cur.close()

        flash("User added successfully!", "success")  # Flash a success message
        return redirect(url_for('register'))  # Changed redirection to `register`

    return render_template('register.html')


@app.route('/search', methods=['GET'])
def search():
    query = request.args.get('query')
    if query:
        # Normalize the query
        query = query.lower()

        # Search for clothing items based on the query
        cur = mysql_client.cursor()
        cur.execute(
            "SELECT * FROM clothing_item WHERE LOWER(color) LIKE %s OR LOWER(season) LIKE %s OR LOWER(cloth_description) LIKE %s",
            (f'%{query}%', f'%{query}%', f'%{query}%')
        )
        results = cur.fetchall()
        cur.close()
        
        return render_template('search_results.html', results=results)
    
    return redirect(url_for('index'))


# Route to serve individual item HTML pages
@app.route('/item/<item_name>')
def item(item_name):
    # Render the specific item HTML page
    return render_template(f'{item_name}.html')


@app.route('/tops')
def tops():
    return render_template('tops.html')

@app.route('/bottoms')
def bottoms():
    return render_template('bottoms.html')

@app.route('/shoes')
def shoes():
    return render_template('shoes.html')

@app.route('/acc')
def acc():
    return render_template('acc.html')

@app.route('/brands')
def brands():
    return render_template('brands.html')

@app.route('/saved')
def saved():
    return render_template('saved.html')

@app.route('/imprint')
def imprint():
    return render_template('imprint.html')

@app.route('/maintenance_err')
def maintenance_err():
    return render_template('maintenance_err.html')


@app.route('/maintenance')
def maintenance():
    # Check if the user is logged in and is 'admin'
    if 'loggedin' in session and session['username'] == 'admin':
        return render_template('maintenance.html')
    else:
        return redirect(url_for('maintenance_err'))



@app.route('/index')  # The second `index` function is kept here
def index():
    if 'loggedin' in session:
        return render_template('index.html', username=session['username'])
    return redirect(url_for('signin'))  # Redirect to sign-in if not logged in

@app.route('/signout')
def signout():
    session.pop('loggedin', None)
    session.pop('username', None)
    return redirect(url_for('signin'))

@app.route('/signin', methods=['GET', 'POST'])
def signin():
    msg = ''
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cur = mysql_client.cursor()
        cur.execute('SELECT * FROM users WHERE username=%s AND password=%s', (username, password))
        record = cur.fetchone()

        if record:
            session['loggedin'] = True
            session['username'] = record[1]
            return redirect(url_for('index'))  # Redirect to the main index page
        else:
            msg = 'Incorrect username or password'

    return render_template('signin.html', msg=msg)

if __name__ == '__main__':
    app.run

# Sample data for autocomplete (in a real app, this would come from a database)
items = [
    "T-Shirt",
    "Jeans",
    "Jacket",
    "Sweater",
    "Shoes",
    "Socks",
    "Scarf",
    "Hat",
    "Blouse",
    "Skirt",
    "Shorts",
    "Dress"
]

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/autocomplete_search', methods=['GET'])
def autocomplete_search():
    # Get the search term from the request
    term = request.args.get('term', '')
    
    # Filter the items based on the search term (case-insensitive)
    matches = [item for item in items if term.lower() in item.lower()]
    
    return jsonify(matches)

if __name__ == '__main__':
    app.run(debug=True)

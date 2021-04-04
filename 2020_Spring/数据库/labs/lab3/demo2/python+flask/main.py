import flask
app = flask.Flask(__name__)
 
@app.route('/')
def hello():
    return '你好'
 
@app.route('/hi')
def hi():
    return 'Hi，'
 
app.run(host='0.0.0.0', port=5000, debug = True)
 
if __name__ == 'main__':
    app.run()
from app import app, database, functions

@app.app.route('/')
def main():
    return "hello"

if __name__ == '__main__':
    app.app.run(host='localhost', port=5000, debug=True)
    main()

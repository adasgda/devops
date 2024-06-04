from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/bmi', methods=['GET'])
def calculate_bmi():
    height = float(request.args.get('height'))
    weight = float(request.args.get('weight'))
    bmi = weight / (height ** 2)
    return jsonify(bmi=bmi)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

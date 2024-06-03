from flask import Flask, request, jsonify

app = Flask(__BMI__)

@app.route('/bmi', methods=['POST'])
def calculate_bmi():
    data = request.json
    weight = data.get('weight')
    height = data.get('height')

    if not weight or not height:
        return jsonify({'error': 'Please provide weight and height'}), 400

    try:
        bmi = weight / (height ** 2)
        return jsonify({'bmi': bmi}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

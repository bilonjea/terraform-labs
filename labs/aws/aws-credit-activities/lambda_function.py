def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": """
        <!DOCTYPE html>
        <html>
        <head>
            <title>AWS Lambda Web App</title>
        </head>
        <body>
            <h1>Hello from AWS Lambda!</h1>
            <p>Application Web créée avec Terraform.</p>
        </body>
        </html>
        """
    }
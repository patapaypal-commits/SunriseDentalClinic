<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sunrise Dental - Login</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-image: url('background.png');
            background-size: cover;
            background-position: center;
            background-color: #1A1A2E;
            font-family: 'Segoe UI', Arial, Helvetica, sans-serif;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding-right: 9%;
        }

        .login-box {
            width: 420px;
            min-height: 480px;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.06);
            overflow: hidden;
            padding: 40px 36px;
        }

        .header {
            text-align: center;
            margin-bottom: 28px;
        }

        .header h1 {
            color: #FFFFFF;
            font-size: 28px;
            font-weight: 600;
            margin: 0;
        }

        .header h1::after {
            content: "Login to continue to Sunrise Dental Care";
            display: block;
            color: rgba(255, 255, 255, 0.4);
            font-size: 14px;
            font-weight: normal;
            margin-top: 8px;
        }

        .body {
            width: 100%;
        }

        label {
            color: rgba(255, 255, 255, 0.7);
            font-weight: 600;
            font-size: 14px;
            display: block;
            margin-bottom: 6px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 16px;
            margin: 0 0 20px 0;
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.04);
            color: #FFFFFF;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
            font-family: 'Times New Roman', Times, serif;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #3D83C7;
            box-shadow: 0 0 0 3px rgba(61, 131, 199, 0.15);
            background: rgba(255, 255, 255, 0.06);
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder {
            color: rgba(255, 255, 255, 0.25);
        }

        .btn {
            background: rgba(61, 131, 199, 0.8);
            color: white;
            padding: 14px 28px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: 700;
            font-family: 'Times New Roman', Times, serif;
            transition: background 0.3s;
            margin-top: 4px;
        }

        .btn:hover {
            background: #3D83C7;
        }

        .error {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 18px;
            font-size: 14px;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            body {
                justify-content: center;
                padding-right: 0;
                padding: 20px;
            }
            .login-box {
                width: 100%;
                max-width: 420px;
                padding: 30px 24px;
            }
        }
    </style>
</head>

<body>

<div class="login-box">

    <div class="header">
        <h1>Welcome Back!</h1>
    </div>

    <div class="body">

        <div class="error">${errorMessage}</div>

        <form action="LoginServlet" method="post">

            <label>Username</label>
            <input type="text" name="username" placeholder="Enter your username" required>

            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required>

            <button type="submit" class="btn">Login</button>

        </form>

    </div>

</div>

</body>
</html>
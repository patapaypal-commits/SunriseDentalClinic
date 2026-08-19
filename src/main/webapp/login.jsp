<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sunrise Dental - Login</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            background-image: url('background.png');
            background-size: cover;
            background-position: center;
            background-color: #F4F8FB;
            font-family: Arial, Helvetica, sans-serif;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding-right: 9%;
        }

        .login-box {
            width: 440px;
            min-height: 500px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-radius: 28px;
            box-shadow: 0 15px 45px rgba(30, 60, 100, 0.18);
            border: 1px solid rgba(255, 255, 255, 0.7);
            overflow: hidden;
        }

        .header {
            background: transparent;
            padding: 45px 30px 15px;
            text-align: center;
        }

        .header::before {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 78px;
            height: 78px;
            margin: 0 auto 25px;
            background: white;
            border-radius: 50%;
            box-shadow: 0 5px 20px rgba(30, 60, 100, 0.12);
            font-size: 34px;
        }

        .header h1 {
            color: #263e5e;
            font-size: 30px;
            margin: 0;
            font-weight: 600;
        }

        .header h1::after {
            content: "Login to continue to Sunrise Dental Care";
            display: block;
            color: #687789;
            font-size: 14px;
            font-weight: normal;
            margin-top: 12px;
        }

        .body {
            padding: 25px 45px 50px;
        }

        label {
            color: #2C3E50;
            font-weight: 500;
            display: block;
            margin-bottom: 7px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 16px 18px;
            margin: 0 0 22px 0;
            border: 1px solid #d7e0ea;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.8);
            color: #2C3E50;
            font-size: 15px;
            transition: 0.3s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #4d8ed6;
            box-shadow: 0 0 0 4px rgba(77, 142, 214, 0.12);
        }

        .btn {
            background: linear-gradient(135deg, #3d83c7, #2f67ad);
            color: white;
            padding: 16px;
            border: none;
            border-radius: 13px;
            cursor: pointer;
            width: 100%;
            font-size: 17px;
            font-weight: 500;
            box-shadow: 0 8px 18px rgba(47, 103, 173, 0.25);
            transition: 0.3s;
            margin-top: 5px;
        }

        .btn:hover {
            background: linear-gradient(135deg, #3477ba, #255894);
            transform: translateY(-2px);
            box-shadow: 0 10px 22px rgba(47, 103, 173, 0.3);
        }

        .error {
            color: #d9534f;
            text-align: center;
            margin-bottom: 18px;
            font-size: 14px;
        }

        @media (max-width: 768px) {
            body {
                justify-content: center;
                padding-right: 0;
                padding: 20px;
            }

            .login-box {
                width: 100%;
                max-width: 440px;
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
            <input type="text" name="username" required>

            <label>Password</label>
            <input type="password" name="password" required>

            <button type="submit" class="btn">Login</button>

        </form>

    </div>

</div>

</body>
</html>
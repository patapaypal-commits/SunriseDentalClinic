<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String appNo = (String) session.getAttribute("receiptAppNo");
    String patient = (String) session.getAttribute("receiptPatient");
    String address = (String) session.getAttribute("receiptAddress");
    String contact = (String) session.getAttribute("receiptContact");
    String dentist = (String) session.getAttribute("receiptDentist");
    String treatment = (String) session.getAttribute("receiptTreatment");
    String cost = (String) session.getAttribute("receiptCost");
    String consultation = (String) session.getAttribute("receiptConsultation");
    String total = (String) session.getAttribute("receiptTotal");
    String date = (String) session.getAttribute("receiptDate");
    String time = (String) session.getAttribute("receiptTime");
    String status = (String) session.getAttribute("receiptStatus");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Receipt - Sunrise Dental</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #1A1A2E;
            font-family: 'Segoe UI', Arial, Helvetica, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .receipt-container {
            position: relative;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(16px);
            border-radius: 18px;
            padding: 22px 28px;
            max-width: 520px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.06);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            min-height: 400px;
        }

        .watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: 0.10;
            pointer-events: none;
            z-index: 0;
            width: 200px;
            height: auto;
        }

        .watermark img {
            width: 100%;
            height: auto;
            display: block;
        }

        .receipt-content {
            position: relative;
            z-index: 1;
        }

        .receipt-header {
            text-align: center;
            border-bottom: 2px solid rgba(61, 131, 199, 0.2);
            padding-bottom: 8px;
            margin-bottom: 10px;
        }

        .receipt-header .clinic-name {
            color: #3D83C7;
            font-size: 18px;
            font-weight: 700;
            letter-spacing: 1px;
        }

        .receipt-header .clinic-tagline {
            color: rgba(255, 255, 255, 0.25);
            font-size: 9px;
            margin-top: 1px;
            letter-spacing: 2px;
        }

        .receipt-header .receipt-title {
            color: rgba(255, 255, 255, 0.5);
            font-size: 11px;
            margin-top: 3px;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .receipt-header .receipt-number {
            color: rgba(255, 255, 255, 0.25);
            font-size: 9px;
            margin-top: 1px;
        }

        .receipt-body {
            margin-bottom: 6px;
        }

        .row {
            display: flex;
            justify-content: space-between;
            padding: 3px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        }

        .row .label {
            color: rgba(255, 255, 255, 0.4);
            font-size: 10px;
            font-weight: 500;
        }

        .row .value {
            color: #FFFFFF;
            font-size: 10px;
            font-weight: 600;
        }

        .row .value.amount {
            color: #2ecc71;
            font-size: 11px;
        }

        .divider {
            border-top: 1px dashed rgba(255, 255, 255, 0.06);
            margin: 2px 0;
        }

        .receipt-total {
            border-top: 2px solid rgba(61, 131, 199, 0.2);
            padding-top: 5px;
            margin-top: 3px;
        }

        .receipt-total .row .label {
            font-size: 12px;
            font-weight: 700;
            color: #FFFFFF;
        }

        .receipt-total .row .value {
            font-size: 14px;
            font-weight: 700;
            color: #2ecc71;
        }

        .status-section {
            text-align: center;
            margin: 5px 0 6px 0;
        }

        .status-badge {
            padding: 2px 14px;
            border-radius: 20px;
            font-size: 9px;
            font-weight: 700;
            color: white;
            display: inline-block;
            letter-spacing: 1px;
        }

        .status-paid {
            background: #27AE60;
        }
        .status-unpaid {
            background: #E67E22;
        }

        .footer-text {
            text-align: center;
            color: rgba(255, 255, 255, 0.12);
            font-size: 8px;
            margin-top: 6px;
            letter-spacing: 1px;
        }

        .btn-print {
            background: rgba(61, 131, 199, 0.9);
            color: white;
            padding: 8px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 700;
            font-size: 13px;
            width: 100%;
            margin-top: 6px;
            font-family: 'Segoe UI', Arial, sans-serif;
            transition: background 0.3s;
            letter-spacing: 1px;
        }

        .btn-print:hover {
            background: #3D83C7;
        }

        .btn-back {
            background: rgba(255, 255, 255, 0.06);
            color: rgba(255, 255, 255, 0.6);
            padding: 7px;
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 11px;
            width: 100%;
            margin-top: 4px;
            text-decoration: none;
            display: block;
            text-align: center;
            font-family: 'Segoe UI', Arial, sans-serif;
            transition: background 0.3s;
        }

        .btn-back:hover {
            background: rgba(255, 255, 255, 0.12);
            color: #FFFFFF;
        }

        @media (max-width: 600px) {
            .receipt-container {
                padding: 15px;
            }
        }

      
        @media print {
            body {
                background: white !important;
                padding: 0 !important;
                margin: 0 !important;
                display: block !important;
                font-family: 'Times New Roman', Times, serif !important;
            }

            .receipt-container {
                background: white !important;
                backdrop-filter: none !important;
                box-shadow: none !important;
                border: 1px solid #ddd !important;
                border-radius: 0 !important;
                padding: 12px 15px !important;
                max-width: 100% !important;
                width: 100% !important;
                margin: 0 auto !important;
                min-height: auto !important;
                page-break-inside: avoid !important;
                page-break-after: avoid !important;
            }

            .watermark {
                opacity: 0.10 !important;
                width: 180px !important;
            }

            .watermark img {
                width: 100% !important;
            }

            .receipt-header {
                border-bottom: 2px solid #263E5E !important;
                padding-bottom: 5px !important;
                margin-bottom: 6px !important;
            }

            .receipt-header .clinic-name {
                color: #263E5E !important;
                font-size: 16px !important;
                font-weight: 700 !important;
            }

            .receipt-header .clinic-tagline {
                color: #888 !important;
                font-size: 8px !important;
            }

            .receipt-header .receipt-title {
                color: #666 !important;
                font-size: 9px !important;
            }

            .receipt-header .receipt-number {
                color: #999 !important;
                font-size: 8px !important;
            }

            .row {
                padding: 2px 0 !important;
                border-bottom: 1px solid #eee !important;
            }

            .row .label {
                color: #555 !important;
                font-size: 9px !important;
                font-weight: 600 !important;
            }

            .row .value {
                color: #222 !important;
                font-size: 9px !important;
                font-weight: 600 !important;
            }

            .row .value.amount {
                color: #27AE60 !important;
                font-size: 10px !important;
            }

            .divider {
                border-top: 1px dashed #ccc !important;
                margin: 1px 0 !important;
            }

            .receipt-total {
                border-top: 2px solid #263E5E !important;
                padding-top: 4px !important;
                margin-top: 2px !important;
            }

            .receipt-total .row .label {
                color: #222 !important;
                font-size: 11px !important;
                font-weight: 700 !important;
            }

            .receipt-total .row .value {
                color: #27AE60 !important;
                font-size: 13px !important;
                font-weight: 700 !important;
            }

            .status-section {
                margin: 3px 0 4px 0 !important;
            }

            .status-badge {
                padding: 2px 12px !important;
                font-size: 8px !important;
                font-weight: 700 !important;
                color: white !important;
                border: none !important;
            }

            .status-paid {
                background: #27AE60 !important;
                color: white !important;
            }
            .status-unpaid {
                background: #E67E22 !important;
                color: white !important;
            }

            .footer-text {
                color: #aaa !important;
                font-size: 7px !important;
                margin-top: 4px !important;
            }

            .btn-print,
            .btn-back {
                display: none !important;
            }

            @page {
                margin: 0.3cm !important;
                size: A4 !important;
            }

            .receipt-container {
                page-break-inside: avoid !important;
                page-break-after: avoid !important;
            }

            body {
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                color-adjust: exact !important;
            }

            .watermark {
                display: block !important;
            }
        }
    </style>
</head>
<body>

<div class="receipt-container">

    
    <div class="watermark">
        <img src="logo.png" alt="Sunrise Dental">
    </div>

    <div class="receipt-content">

       
        <div class="receipt-header">
            <div class="clinic-name">Sunrise Dental Clinic</div>
            <div class="clinic-tagline">YOUR SMILE, OUR PRIORITY</div>
            <div class="receipt-title">Payment Receipt</div>
            <div class="receipt-number"># <%= appNo != null ? appNo : "N/A" %></div>
        </div>

        
        <div class="receipt-body">

            <div class="row">
                <span class="label">Patient Name</span>
                <span class="value"><%= patient != null ? patient : "N/A" %></span>
            </div>

            <div class="row">
                <span class="label">Contact</span>
                <span class="value"><%= contact != null ? contact : "N/A" %></span>
            </div>

            <div class="row">
                <span class="label">Treatment</span>
                <span class="value"><%= treatment != null ? treatment : "N/A" %></span>
            </div>

            <div class="row">
                <span class="label">Dentist</span>
                <span class="value"><%= dentist != null ? dentist : "N/A" %></span>
            </div>

            <div class="row">
                <span class="label">Date</span>
                <span class="value"><%= date != null ? date : "N/A" %></span>
            </div>

            <div class="row">
                <span class="label">Time</span>
                <span class="value"><%= time != null ? time : "N/A" %></span>
            </div>

            <div class="divider"></div>

            <div class="row">
                <span class="label">Treatment Cost</span>
                <span class="value amount">Rs. <%= cost != null ? cost : "0.00" %></span>
            </div>

            <div class="row">
                <span class="label">Consultation Fee</span>
                <span class="value amount">Rs. <%= consultation != null ? consultation : "0.00" %></span>
            </div>

            <div class="row receipt-total">
                <span class="label">Total Amount</span>
                <span class="value">Rs. <%= total != null ? total : "0.00" %></span>
            </div>

        </div>

        
        <div class="status-section">
            <span class="status-badge status-<%= "PAID".equalsIgnoreCase(status) ? "paid" : "unpaid" %>">
                <%= status != null ? status : "UNPAID" %>
            </span>
        </div>

        <div class="footer-text">Thank you for visiting Sunrise Dental Clinic</div>

       
        <button class="btn-print" onclick="window.print()"> Print Receipt</button>
        <a href="UserLayoutServlet?page=view-bills" class="btn-back">← Back to Bills</a>

    </div>

</div>

</body>
</html>
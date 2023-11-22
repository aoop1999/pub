<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VPS交易计算器 V5.0</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">VPS交易计算器</h1>
        <form id="calculatorForm">
            <div class="form-group">
                <label for="purchasePrice">续费价格：</label>
                <input type="number" class="form-control" id="purchasePrice" name="purchasePrice" step="0.01" required>
            </div>
            <div class="form-group">
                <label for="tradePrice">交易价格：</label>
                <input type="number" class="form-control" id="tradePrice" name="tradePrice" step="0.01" required>
            </div>
            <div class="form-group">
                <label for="currentDate">当前日期：</label>
                <input type="date" class="form-control" id="currentDate" name="currentDate" required>
            </div>
            <div class="form-group">
                <label for="expiryDate">到期日期：</label>
                <input type="date" class="form-control" id="expiryDate" name="expiryDate" required>
            </div>
            <div class="form-group">
                <label for="paymentFrequency">付款周期：</label>
                <select class="form-control" id="paymentFrequency" name="paymentFrequency" required>
                    <option value="yearly">年付</option>
                    <option value="halfyearly">半年付</option>
                    <option value="quarterly">季付</option>
                    <option value="monthly">月付</option>
                    <option value="two-yearly">二两付</option>
                    <option value="three-yearly">三年付</option>
                    <option value="five-yearly">五年付</option>
                </select>
            </div>
            <button type="button" class="btn btn-primary" onclick="calculateRemainingValue()">计算剩余价值</button>
        </form>

        <div class="result mt-4" style="display: none;">
            <h3>计算结果：</h3>
            <p>续费价格: <span id="resultPurchasePrice"></span></p>
            <p>剩余价值计算周期: <span id="resultPaymentFrequency"></span></p>
            <p>剩余价值: <span id="resultRemainingValue"></span></p>
            <p>交易价格: <span id="resultTradePrice"></span></p>
            <p>溢价金额: <span id="resultPremium"></span></p>
            <p>购买建议: <span id="resultAdvice"></span></p>
        </div>

        <div class="mt-4">
            <h3>计算过程：</h3>
            <div class="accordion" id="calculationProcess">
                <div class="card">
                    <div class="card-header" id="headingOne">
                        <h2 class="mb-0">
                            <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                展开计算过程
                            </button>
                        </h2>
                    </div>
                    <div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="#calculationProcess">
                        <div class="card-body" id="calculationDetails">
                            <!-- Calculation details will be displayed here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        function calculateRemainingValue() {
            // Retrieve input values
            const purchasePrice = parseFloat(document.getElementById("purchasePrice").value);
            const tradePrice = parseFloat(document.getElementById("tradePrice").value);
            const currentDate = new Date(document.getElementById("currentDate").value);
            const expiryDate = new Date(document.getElementById("expiryDate").value);
            const paymentFrequency = document.getElementById("paymentFrequency").value;

            // Calculate remaining days
            const remainingDays = Math.floor((expiryDate - currentDate) / (24 * 60 * 60 * 1000));
            const remainingMonths = Math.floor(remainingDays / 30);

            // Calculate remaining value
            let paymentFrequency_ = "";
            let remainingValue = 0;

            switch (paymentFrequency) {
                case "quarterly":
                    paymentFrequency_ = "季付";
                    remainingValue = purchasePrice / 90 * remainingDays;
                    break;
                case "yearly":
                    paymentFrequency_ = "年付";
                    remainingValue = purchasePrice / 365 * remainingDays;
                    break;
                case "halfyearly":
                    paymentFrequency_ = "半年付";
                    remainingValue = purchasePrice / 180 * remainingDays;
                    break;
                case "monthly":
                    paymentFrequency_ = "月付";
                    remainingValue = purchasePrice / 30 * remainingDays;
                    break;
                case "two-yearly":
                    paymentFrequency_ = "二两付";
                    remainingValue = purchasePrice / (365 * 2) * remainingDays;
                    break;
                case "three-yearly":
                    paymentFrequency_ = "三年付";
                    remainingValue = purchasePrice / (365 * 3) * remainingDays;
                    break;
                case "five-yearly":
                    paymentFrequency_ = "五年付";
                    remainingValue = purchasePrice / (365 * 5) * remainingDays;
                    break;
            }

            const premium = tradePrice - remainingValue;

            // Display results
            document.getElementById("resultPurchasePrice").textContent = purchasePrice;
            document.getElementById("resultPaymentFrequency").textContent = paymentFrequency_;
            document.getElementById("resultRemainingValue").textContent = remainingValue;
            document.getElementById("resultTradePrice").textContent = tradePrice;
            document.getElementById("resultPremium").textContent = premium;

            // Determine advice
            let advice = "";
            if (premium > 0) {
                advice = "存在溢价，请君三思而后行";
            } else if (premium < 0) {
                advice = "卖家血亏，快买，错过拍断大腿！";
            } else {
                advice = "不议价，良心卖家！";
            }
            document.getElementById("resultAdvice").textContent = advice;

            // Display calculation details
            const calculationDetails = `
                <p>剩余月份：${remainingMonths} 个月（剩余天数：${remainingDays} 天）</p>
                <p>剩余价值 = 历史购买价格 / ${paymentFrequency === 'yearly' ? 365 : (paymentFrequency === 'halfyearly' ? 180 : (paymentFrequency === 'quarterly' ? 90 : (paymentFrequency === 'monthly' ? 30 : (paymentFrequency === 'two-yearly' ? 730 : (paymentFrequency === 'three-yearly' ? 1095 : 1825)))))} * 剩余天数</p>
                <p>剩余价值 = ${purchasePrice} / ${paymentFrequency === 'yearly' ? 365 : (paymentFrequency === 'halfyearly' ? 180 : (paymentFrequency === 'quarterly' ? 90 : (paymentFrequency === 'monthly' ? 30 : (paymentFrequency === 'two-yearly' ? 730 : (paymentFrequency === 'three-yearly' ? 1095 : 1825)))))} * ${remainingDays} = ${remainingValue}</p>
            `;
            document.getElementById("calculationDetails").innerHTML = calculationDetails;

            // Show the result section
            document.querySelector(".result").style.display = "block";
        }
    </script>
</body>
</html>

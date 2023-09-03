-- CGBanking Configuration
CGBanking.Config = CGBanking.Config or {}

-- How much money (if any at all), should people get at the beginning
CGBanking.Config.StartingBankAccountBalance = 5000

-- Some settings for the community themeing
-- theese are some basics, the rest of the theming is down below
CGBanking.Config.CommunityName = "CGBanking Network"
CGBanking.Config.CommunityColor = Color(255, 75, 75)

-- The max amount of money any singular entity can hold
CGBanking.Config.MaxMoney = 999999999

-- time in seconds between interest payments
CGBanking.Config.InterestTimer = 500
-- The interest any person will get
-- 0.25 = 25%
-- 1 = 100%
CGBanking.Config.Interest = 0.001
CGBanking.Config.MaxInterest = 5000 -- The max amount of money someone can get from one interest payment, -1 will mean this is ignored!

-- Allow people to use the banking commands to access the ATM anywhere?
CGBanking.Config.ATMCommand = true
CGBanking.Config.ATMCommands = {"/banking", "!banking"} -- the commands to open the menu

-- Language and translation strings throughout the addon
CGBanking.Lang = {
    ["interest_payment"] = "You have recieved an interest payment from the bank for {AMT}.",
    ["cant_afford"] = "You can't afford to deposit this much money!",
    ["cant_withdraw"] = "You don't have that much money in the bank!",
    ["deposit_complete"] = "You have deposited {AMT} into the bank!",
    ["withdraw_complete"] = "You have withdrawn {AMT} from the bank!",
    ["withdraw"] = "Withdraw",
    ["deposit"] = "Deposit",
    ["amount"] = "Amount",
    ["balance_money"] = "Balance: {AMT}",
    ["balance_loading"] = "Balance: Loading...",
    ["new_balance_waiting"] = "New Balance: waiting for input",
    ["new_balance_money"] = "New Balance: {AMT}",
    ["submit"] = "Submit",
    ["atm"] = "ATM",
}

CGBanking.Theme = {
    FrameBackground = Color(0, 0, 0, 200),
    Text = Color(255, 255, 255),
    AtmBackground = Color(0, 0, 0, 200),
    AtmText = Color(255, 255, 255),
}

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

-- The interest any person will get
-- 0.25 = 25%
-- 1 = 100%
CGBanking.Config.Interest = 0.25
CGBanking.Config.MaxInterest = -1 -- The max amount of money someone can get from one interest payment, -1 will mean this is ignored!

-- Language and translation strings throughout the addon
CGBanking.Lang = {
    ["interest_payment"] = "You have recieved an interest payment from the bank for %s.",
    ["withdraw"] = "Withdraw",
    ["deposit"] = "Deposit",
    ["transfer"] = "Transfer",
    ["leaderboard"] = "Money Leaderboard (Bank)"
}

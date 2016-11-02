
#Predicting Email Addresses
      
def predict_email_address(email_data,user_data):
    outcome = []
    for email in email_data:
        if email == user_data[1].strip().lower():
            if user_data[1].strip().lower() == "alphasights.com":
                outcome.append(user_data[0].lower().replace(" ",".").strip() + "@" + email)
            elif user_data[1].strip().lower() == "google.com":
                outcome.extend([user_data[0][0].lower() + "." + user_data[0][user_data[0].find(" ")+1:].lower() +  "@" + email,
                user_data[0][:user_data[0].find(" ")].lower() + "." +  user_data[0][user_data[0].find(" ")+1].lower() +  "@" + email])
            elif user_data[1].strip().lower() == "apple.com":
                outcome.append(user_data[0][0].lower() + "." + user_data[0][user_data[0].find(" ")+1].lower() +  "@" + email)
    if len(outcome) == 0:
        outcome.extend([
        user_data[0].lower().replace(" ",".").strip() + "@" + user_data[1],
        user_data[0][:user_data[0].find(" ")].lower() + "." +  user_data[0][user_data[0].find(" ")+1].lower() +  "@" + user_data[1],
        user_data[0][0].lower() + "." + user_data[0][user_data[0].find(" ")+1:].lower() +  "@" + user_data[1],
        user_data[0][0].lower() + "." + user_data[0][user_data[0].find(" ")+1].lower() +  "@" + user_data[1]])
    return outcome        
        

def main():
    current_data = ["alphasights.com","google.com","apple.com"]
    test_data = [["Damon Aw","alphasights.com"],
                 ["Craig Silverstein","google.com"],
                 ["Steve Wozniak", "apple.com"],
                 ["Barack Obama", "whitehouse.gov"],
                 ["Peter Wong", "alphasights.com"]] 
    
    for user_data in test_data:
        print(predict_email_address(current_data,user_data))

if __name__ == "__main__":
    main()
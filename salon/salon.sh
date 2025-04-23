#!/bin/bash

#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # echo "Here are the services we offer:" 
  # echo -e "\n1) Male Cut\n2) Female Cut\n3) Male style\n4) Female style\n5) Colour\n6) Shave\n7) Treatment\n8) Exit"
  # display services
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")

  # echo -e "\nPlease select one of our services:"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME  
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  # echo "8) EXIT"

  echo -e "\nWhich service would you like?"

  read SERVICE_ID_SELECTED

  # check if selected service is a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "Please select a valid service"
  else
    # get service id if exists
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_NAME ]]
    then
      MAIN_MENU "This service does not exist."      
    fi
    
    echo "What's your phone number?"
    read CUSTOMER_PHONE

    # check if customer exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if not exists, create customer
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nEnter your name:"
      read CUSTOMER_NAME
      CUSTOMER_INSERT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    # get cutomer id 
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'") 

    # get time input
    echo -e "\nPlease enter an appointment time:"
    read SERVICE_TIME

    # create appointment with details
    APPOINTMENT_INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    # output confirmation message
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')." 



  fi

}

MAIN_MENU


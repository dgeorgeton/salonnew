#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# service menu

SERVICE_MENU() {
  SERVICES=$($PSQL "SELECT * FROM services")

  echo -e "Input a number to choose a service:"
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do 
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
}

SERVICE_MENU 

SERVICE_CHECK=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
while [[ -z $SERVICE_CHECK ]]
do
  echo Sorry, please choose another service.
  SERVICE_MENU 
  SERVICE_CHECK=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
done
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_CHECK")

echo -e "\nWhat's your phone number?\n"
read CUSTOMER_PHONE
HAVE_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $HAVE_PHONE ]]
then 
  echo -e "\nPlease input your name\n"
  read CUSTOMER_NAME
  NAME_NUMBER_INSERT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo Hi, $CUSTOMER_NAME
  else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo Hi, $CUSTOMER_NAME.
fi


echo -e "\nWhat time works best for you?\n"
read SERVICE_TIME

MAKE_APPT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")

echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n"

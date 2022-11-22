( echo -n "body="  ;  cat file.xml ) | curl --data-binary '@-' -d "customProperty=value" "http://admin:admin@localhost:8161/api/message/$QueueName?type=$QueueType"

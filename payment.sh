source common.sh

if [ -z "${rabbitmq_pass}" ]; then
        echo "rabbitmq pass is missing"
fi


component=payment

schema_load=false

python

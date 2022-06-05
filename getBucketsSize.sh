buckets=($(aws s3 ls | awk '{print $3}' ))


echo "Count Buckets ${#buckets[*]}"

for bucket in "${buckets[@]}" ;
do

	echo "BUCKET "
	echo "$bucket"
        command="aws s3 ls --summarize --recursive s3://$bucket | grep 'Total Size'"
	echo $command
        aws s3 ls --summarize --human-readable --recursive s3://$bucket | grep 'Total Size'
	echo  ""
done




DEBUG=0
REGION="us-west-2"

NOW=$(date +%FT%TZ)
let PERIOD="60*60*24"



ENDTIME=$(date -d "$NOW -1 days" +%FT%TZ)
STARTTIME=$(date -d "$NOW -2 days" +%FT%TZ )

let KB="1024*1"
let MB="1024*KB"
let GB="1024*MB"

STORAGE_CLASS="StandardStorage"

buckets=($(aws s3 ls | awk '{print $3}' ))


for bucket in "${buckets[@]}" ;
do

	if [ $DEBUG -eq 1 ]; then
		echo ""

		echo "$NOW";
		echo "starttime $STARTTIME";
		echo "endtime $ENDTIME";
		echo "periodo $PERIOD";
		echo "region $REGION";
		echo "bucket $bucket";
		echo "Storage $STORAGE_CLASS";
	fi


        BUCKET_SIZE_BYTES=$(aws cloudwatch \
                                get-metric-statistics \
                                --namespace "AWS/S3" \
                                --start-time "$STARTTIME" \
                                --end-time "$ENDTIME" \
                                --period $PERIOD \
                                --statistics "Average" \
                                --region "$REGION" \
                                --metric-name "BucketSizeBytes" \
                                --dimensions Name=BucketName,Value=$bucket  Name=StorageType,Value=$STORAGE_CLASS  | jq '.Datapoints[].Average' )


if  [[ $BUCKET_SIZE_BYTES > 1 ]]; then
	BUCKET_SIZE_BYTES=$BUCKET_SIZE_BYTES
else
	BUCKET_SIZE_BYTES=0
	continue 
fi

echo -n "BUCKET $bucket" 
echo -n " $BUCKET_SIZE_BYTES "

let BUCKET_SIZE_KB="BUCKET_SIZE_BYTES / KB"
#echo "SIZE $BUCKET_SIZE_KB KB"

let BUCKET_SIZE_MB="BUCKET_SIZE_BYTES / MB"
#echo "SIZE $BUCKET_SIZE_MB MB"

let BUCKET_SIZE_GB="BUCKET_SIZE_BYTES / GB"
echo " $BUCKET_SIZE_GB GB"

done;

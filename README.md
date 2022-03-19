# Build and Run Clickhouse

## Build and run Clickhouse from source (Ubuntu 20.04)

1. install dependencies
```sh
# install clang++-14/clang-14
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 14

sudo apt install -y git bash cmake ninja-build libicu-dev libreadline-dev gperf expect python python-lxml python-termcolor python-requests curl perl sudo openssl netcat-openbsd telnet
```

2. download source
```sh
git clone https://github.com/yandex/ClickHouse.git && cd ClickHouse
# I use 22.2 version
git checkout 22.2 && git pull && git submodule init && git submodule update --jobs 4
```

3. configure and make
```sh
mkdir build_release && cd build_release

cmake .. -DCMAKE_CXX_COMPILER=/usr/bin/clang++-14 -DCMAKE_C_COMPILER=/usr/bin/clang-14 -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE -DCMAKE_BUILD_TYPE=Release

cmake --build . --parallel 4
```

4. run server
```sh
./programs/clickhouse-server
```


5. run client
```sh
./programs/clickhouse-client
```

## Run Clickhouse cluster on docker (Ubuntu 20.04)

Clickhouse cluster with 4 shards and 1 replicas built with docker-compose.

1. install docker and docker-compose
```sh
sudo apt-get update && sudo apt-get install ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose

# add current user to docker group, then exit and re-login
sudo usermod -aG docker $USER
```

2. generate cluster config

```sh
make config
```

3. run culster

```sh
make up
```

Containers will be available in docker network `172.23.0.0/24`

| Container    | Address
| ------------ | -------
| zookeeper    | 172.23.0.10
| clickhouse01 | 172.23.0.11
| clickhouse02 | 172.23.0.12
| clickhouse03 | 172.23.0.13
| clickhouse04 | 172.23.0.14

## Profiles

- `default` - no password
- `admin` - password `admin`

## Test distributed table

Get example dataset
```sh
curl https://datasets.clickhouse.com/hits/tsv/hits_v1.tsv.xz | unxz --threads=`nproc` > hits_v1.tsv
```

Create example table (sharded and replicated)
```sql
CREATE TABLE hits_v1 ON CLUSTER 'ch_cluster' (
    WatchID UInt64,
    JavaEnable UInt8,
    Title String,
    GoodEvent Int16,
    EventTime DateTime,
    EventDate Date,
    CounterID UInt32,
    ClientIP UInt32,
    ClientIP6 FixedString(16),
    RegionID UInt32,
    UserID UInt64,
    CounterClass Int8,
    OS UInt8,
    UserAgent UInt8,
    URL String,
    Referer String,
    URLDomain String,
    RefererDomain String,
    Refresh UInt8,
    IsRobot UInt8,
    RefererCategories Array(UInt16),
    URLCategories Array(UInt16),
    URLRegions Array(UInt32),
    RefererRegions Array(UInt32),
    ResolutionWidth UInt16,
    ResolutionHeight UInt16,
    ResolutionDepth UInt8,
    FlashMajor UInt8,
    FlashMinor UInt8,
    FlashMinor2 String,
    NetMajor UInt8,
    NetMinor UInt8,
    UserAgentMajor UInt16,
    UserAgentMinor FixedString(2),
    CookieEnable UInt8,
    JavascriptEnable UInt8,
    IsMobile UInt8,
    MobilePhone UInt8,
    MobilePhoneModel String,
    Params String,
    IPNetworkID UInt32,
    TraficSourceID Int8,
    SearchEngineID UInt16,
    SearchPhrase String,
    AdvEngineID UInt8,
    IsArtifical UInt8,
    WindowClientWidth UInt16,
    WindowClientHeight UInt16,
    ClientTimeZone Int16,
    ClientEventTime DateTime,
    SilverlightVersion1 UInt8,
    SilverlightVersion2 UInt8,
    SilverlightVersion3 UInt32,
    SilverlightVersion4 UInt16,
    PageCharset String,
    CodeVersion UInt32,
    IsLink UInt8,
    IsDownload UInt8,
    IsNotBounce UInt8,
    FUniqID UInt64,
    HID UInt32,
    IsOldCounter UInt8,
    IsEvent UInt8,
    IsParameter UInt8,
    DontCountHits UInt8,
    WithHash UInt8,
    HitColor FixedString(1),
    UTCEventTime DateTime,
    Age UInt8,
    Sex UInt8,
    Income UInt8,
    Interests UInt16,
    Robotness UInt8,
    GeneralInterests Array(UInt16),
    RemoteIP UInt32,
    RemoteIP6 FixedString(16),
    WindowName Int32,
    OpenerName Int32,
    HistoryLength Int16,
    BrowserLanguage FixedString(2),
    BrowserCountry FixedString(2),
    SocialNetwork String,
    SocialAction String,
    HTTPError UInt16,
    SendTiming Int32,
    DNSTiming Int32,
    ConnectTiming Int32,
    ResponseStartTiming Int32,
    ResponseEndTiming Int32,
    FetchTiming Int32,
    RedirectTiming Int32,
    DOMInteractiveTiming Int32,
    DOMContentLoadedTiming Int32,
    DOMCompleteTiming Int32,
    LoadEventStartTiming Int32,
    LoadEventEndTiming Int32,
    NSToDOMContentLoadedTiming Int32,
    FirstPaintTiming Int32,
    RedirectCount Int8,
    SocialSourceNetworkID UInt8,
    SocialSourcePage String,
    ParamPrice Int64,
    ParamOrderID String,
    ParamCurrency FixedString(3),
    ParamCurrencyID UInt16,
    GoalsReached Array(UInt32),
    OpenstatServiceName String,
    OpenstatCampaignID String,
    OpenstatAdID String,
    OpenstatSourceID String,
    UTMSource String,
    UTMMedium String,
    UTMCampaign String,
    UTMContent String,
    UTMTerm String,
    FromTag String,
    HasGCLID UInt8,
    RefererHash UInt64,
    URLHash UInt64,
    CLID UInt32,
    YCLID UInt64,
    ShareService String,
    ShareURL String,
    ShareTitle String,
    ParsedParams Nested(
        Key1 String,
        Key2 String,
        Key3 String,
        Key4 String,
        Key5 String,
        ValueDouble Float64
    ),
    IslandID FixedString(16),
    RequestNum UInt32,
    RequestTry UInt8
) ENGINE = ReplicatedMergeTree('/clickhouse/tables/{cluster}/{shard}/table', '{replica}') 
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate, intHash32(UserID))
SAMPLE BY intHash32(UserID)
SETTINGS index_granularity = 8192;

CREATE TABLE hits_v1_dist ON CLUSTER 'ch_cluster' AS hits_v1
ENGINE = Distributed('ch_cluster', default, hits_v1, UserID);
```

insert example data
```sh
cat hits_v1.tsv | clickhouse-client --query "INSERT INTO hits_v1_dist FORMAT TSV" --max_insert_block_size=100000
```

Check data from current shard
```sql
select count(1) from hits_v1;
```

Check data from all cluster
```sql
select count(1) from hits_v1_dist;
```

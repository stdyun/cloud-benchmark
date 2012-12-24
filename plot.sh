#!/bin/bash

# unixbench
unixbench() {
    log_name=`find . -name "unixbench*.log" | sort`
    log_name_arr=(${log_name})
    
    for i in ${log_name_arr[@]}; do
        score=`grep "System Benchmarks Index Score" ${i} | awk '{print $5}'`
        time=`echo ${i} | cut -c 23-41`
        #echo "u:"${time}":"${score}
    done
    s_arr=(${score})
    echo "  Morris.Bar({
    element: 'cpu_perf',
    data: [
      {device: 'UnixBench单核', unixbench: ${s_arr[0]}},
      {device: 'UnixBench双核', unixbench: ${s_arr[1]}},
    ],
    xkey: 'device',
    ykeys: ['unixbench'],
    labels: ['unixbench'],
    barRatio: 0.4,
    barColors: ['#87A3BB',],
  });"
}

# iostone
iostone() {
    log_name=`find . -name "iozone*.log" | sort`
    log_name_arr=(${log_name})

    for i in ${log_name_arr[@]}; do
        score=`grep "         [0-9]" ${i} | awk '{print $3" "$5" "$7" "$8}'`
        time=`echo ${i} | cut -c 17-35`
        #echo "i:"${time}":"${score}
    done
    s_arr=(${score})
    echo "  Morris.Bar({
    element: 'io_perf',
    data: [
      {device: 'iozone-read', iozone: ${s_arr[0]}},
      {device: 'iozone-write', iozone: ${s_arr[1]}},
      {device: 'iozone-rread', iozone: ${s_arr[2]}},
      {device: 'iozone-rwrite', iozone: ${s_arr[3]}},
    ],
    xkey: 'device',
    ykeys: ['iozone'],
    labels: ['MB/s'],
    barRatio: 0.4,
    barColors: ['#87A3BB',],
  });
"
}

# mbw
mbw() {
    log_name=`find . -name "mbw*.log" | sort`
    log_name_arr=(${log_name})

    for i in ${log_name_arr[@]}; do
        score=`grep "AVG" ${i} | awk '{print $9}'`
        time=`echo ${i} | cut -c 11-29`
        #echo "m:"${time}":"${score}
    done
    s_arr=(${score})
    echo "  Morris.Bar({
    element: 'mem_perf',
    data: [
      {device: 'mbw-copy', mbw: ${s_arr[0]}},
      {device: 'mbw-dumb', mbw: ${s_arr[1]}},
      {device: 'mbw-block', mbw: ${s_arr[2]}},
    ],
    xkey: 'device',
    ykeys: ['mbw'],
    labels: ['MB/s'],
    barRatio: 0.4,
    barColors: ['#87A3BB',],
  });"
}

echo '<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>主机性能报告</title>
  <meta name="description" content="">
  <meta name="author" content="stdyun">
  <meta name="viewport" content="width=device-width">
  <script src="modernizr-2.5.3-respond-1.1.0.min.js"></script>
  <link href="cb.css" media="screen" rel="stylesheet" type="text/css" />
</head>
<body>
    <div class="navbar">
    <div class="container">
      <div class="row">
        <div class="span12">
          <h1>主机性能报告</h1>
          <div id="cpu_perf" class="perf"></div>
          <div id="mem_perf" class="perf"></div>
          <div id="io_perf" class="perf"></div>
        </div>
      </div>
      <hr>
      <footer>
        <p>&copy; stdyun</p>
      </footer>
    </div> <!-- /container -->
<script src="jquery.min.js"></script>
<script src="raphael-2.0.2.min.js"></script>
<script src="morris.js"></script>
<script>
$(function () {'

unixbench
iostone
mbw

echo '});   
</script>
</body>
</html>' 


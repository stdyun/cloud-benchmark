#!/usr/bin/env python                                                          
#coding:utf-8                                                                  
from __future__ import with_statement
import sys                                                                     
reload(sys)                                                                    
sys.setdefaultencoding("utf-8")

from fabric.api import run

from fabric.api import env,run

def stdyun():
    env.hosts = ["stdyun-dev.com"]
    env.user = "subdragon"
    env.key_filename = "/Users/subdragon/.ssh/id_rsa"

def ps():
    run("ps aux | grep nginx")

def perpare_env():
    #run("./prepare_env.bash")
    run("apt-get install puppet")

def run_benchmark():
    run("puppet apply cloud-benchmark.pp")

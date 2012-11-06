#!/usr/bin/env python
#coding:utf-8
from __future__ import with_statement
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

from fabric.api import env,run,put,sudo

def stdyun():
    env.hosts = ["stdyun-dev.com"]
    env.user = "subdragon"
    env.key_filename = "/Users/subdragon/.ssh/id_rsa"

def ps():
    run("ps aux | grep nginx")

def prepare_env():
    #run("./prepare_env.bash")
    sudo("apt-get install puppet")

def run_benchmark():
    prepare_env()
    put('benchmark.pp', 'benchmark.pp')
    run("screen puppet apply benchmark.pp")

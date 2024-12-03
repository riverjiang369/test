#!/bin/bash

#脚本后面的传参数量,并且这个为参数$1
#双括号的效果会比单括号好

#判断参数是否为0
if [[ $# -eq 0 ]];then
#打印帮助信息
  echo "Usage: bash $0 files or dirs"
#返回非0状态,判断脚本执行
  exit 1
fi

#定义函数------------------

#定义Help
function Help(){
#打印回车方法
  echo "Do you want to continue，input enter to next."
#变量，这里的变量没用
  read -p "" aaa
}

main(){
#定义变量，接受参数1的传参
  mytemp=$1
#定义回收站名称为时间戳+关键词
  D=/temp/$(date +%Y%m%d%H%M%S_shz)
#简写判断,！=反，-d判断这个存在返回布尔值,使用！则取反，不存在创建对应目录
  [ ! -d $D ] && mkdir -p $D
#判断参数，多个文件使用‘，’相隔过滤
  if echo $1|grep ,  &>/dev/null;then
#将，替换为空格
    mytemp="`echo $mytemp|tr ',' '\n'`"
  fi
#迭代变量
  for i in $mytemp
  do
#列出目录是否存在，不管输出正确或错误都输出到黑洞里，不需要打印出来
    if ! ls -l $i &>/dev/null;then
#如果不存在则终止循环
      continue
    fi
#过滤，只要删除带有 'etc|usr|bin'这些关键词则会提示不能删除
    if ls -l $i |grep -Ew 'etc|usr|bin' &>/dev/null;then
      echo "you do not delete [ $i ]"
      continue
    fi
#提示是否删除
    echo "now you want to delete >>> $i <<< " && ls -l $i
#引用了Help函数
    Help
    /bin/mv "$i" $D
#输出日志
    echo "`date +%F-%T` --- "$i" Moved to $D" >> /root/mv_data.log
  done
#列出回收站目录，如果里面的文件数为0，空目录删除
   if [[ `ls -1 $D|wc -l` -eq 0 ]];then
     rm -r $D
   fi
}
#最后会引用参数1
main $1


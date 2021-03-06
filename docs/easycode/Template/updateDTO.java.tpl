##引入宏定义
$!define
##定义初始变量
#set($packageName = $tool.append($tableInfo.savePackageName,".",$tool.firstLowerCase($tableInfo.name)))
#set($className = $tool.append($tableInfo.name, "UpdateDTO"))
#set($fillOnInsertColumn = $tool.newArrayList("deleted","create_time","create_user","update_time","update_user"))
#set($fillOnUpdateColumn = $tool.newArrayList("update_time","update_user"))
#set($versionColumn = "update_time")
#set($logicDeleteColumn = "deleted")
##设置回调
#save($tool.append("/", $tool.firstLowerCase($tableInfo.name),"/service/dto"), "UpdateDTO.java")

## package
#if($packageName)package $!{packageName}#{end}.service.dto;

$!autoImport
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

##使用宏定义实现类注释信息
#tableComment("UpdateDTO")
@ApiModel("$!{className}")
@Getter
@Setter
@Builder
@NoArgsConstructor
public class $!{className} {
#foreach($column in $tableInfo.otherColumn)
    #if(!($fillOnInsertColumn.contains(${column.obj.name}) 
        || $fillOnUpdateColumn.contains(${column.obj.name}) 
        || $versionColumn.equals(${column.obj.name}) 
        || $logicDeleteColumn.equals(${column.obj.name})))
    #if(${column.comment})
    /**
     * ${column.comment}
     */#end
    private $!{tool.getClsNameByFullName($column.type)} $!{column.name};
    #end
    
#end

#foreach($column in $tableInfo.otherColumn)
    #if(!($fillOnInsertColumn.contains(${column.obj.name})
    || $fillOnUpdateColumn.contains(${column.obj.name})
    || $versionColumn.equals(${column.obj.name})
    || $logicDeleteColumn.equals(${column.obj.name})))
        ##使用宏定义实现get,set方法
        #getSetMethod($column)
    #end
#end

}
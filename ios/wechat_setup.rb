#
# 参考文献
# https://github.com/MagicalWater/Base-APP-Env/blob/master/fastlane/actions/xcode_parse.rb
#

require 'xcodeproj'
require 'plist'
require 'optparse'

# Dictionary to hold command line arguments
options_dict = {}

# Parse command line arguments into options_dict
OptionParser.new do |options|
    options.banner = "Setup the Wechat to an Xcode target."

    options.on("-p", "--projectDirectory=DIRECTORY", String, "Directory of the Xcode project") do |dir|
        options_dict[:project_dir] = dir
    end

    options.on("-n", "--projectName=NAME", String, "Name of the Xcode project (ex: Runner.xcodeproj)") do |name|
        options_dict[:project_name] = name
    end

    options.on("-a", "--appId=APPID", String, "App ID for Wechat") do |opts|
        options_dict[:app_id] = opts
    end

    options.on("-u", "--universalLink=UNIVERSALLINK", String, "Universal Link for Wechat") do |opts|
        options_dict[:universal_link] = opts
    end
end.parse!

# Minimum required arguments are a project directory and project name
unless (options_dict[:project_dir] and options_dict[:project_name])
    abort("Must provide a project directory and project name.\n")
end

# Path to the Xcode project to modify
project_path = File.join(options_dict[:project_dir], options_dict[:project_name])

unless (File.exist?(project_path))
   abort("Project at #{project_path} does not exist. Please check paths manually.\n");
end

# Actually open and modify the project
project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|
    if (target.name == "Runner")
        app_id = options_dict[:app_id]
        universal_link = options_dict[:universal_link]

        sectionObject = {}
        project.objects.each do |object|
            if object.uuid == target.uuid
                sectionObject = object
                break
            end
        end
        sectionObject.build_configurations.each do |config|
            codeSignEntitlements = config.build_settings["CODE_SIGN_ENTITLEMENTS"]
            if (!codeSignEntitlements)
                codeSignEntitlements = "Runner/Runner.entitlements"
            end
            codeSignEntitlementsFile = File.join(options_dict[:project_dir], codeSignEntitlements)
            if !File.exist?(codeSignEntitlementsFile)
                content = Plist::Emit.dump({})
                File.write(codeSignEntitlementsFile, content)
            end
            runnerTargetMainGroup = project.main_group.find_subpath('Runner', false)
            isRefExist = runnerTargetMainGroup.files.any? { |file| file.path.include? File.basename(codeSignEntitlementsFile) }
            if !isRefExist
                runnerTargetMainGroup.new_reference(File.basename(codeSignEntitlementsFile))
            end
            result = Plist.parse_xml(codeSignEntitlementsFile, marshal: false)
            if (!result)
                result = {}
            end
            domains = result["com.apple.developer.associated-domains"]
            if (!domains)
                domains = []
                result["com.apple.developer.associated-domains"] = domains
            end
            isApplinksExist = domains.include? "applinks:#{URI.parse(universal_link).host}"
            if (!isApplinksExist)
                domains << "applinks:#{URI.parse(universal_link).host}"
                content = Plist::Emit.dump(result)
                File.write(codeSignEntitlementsFile, content)
            end
            puts("#{domains}")

            project.save()
        end
    end
end



##################### Package Installation Seciont #######################

apt_package ['nginx','php5-fpm','php5-xmlrpc','php5-mysql','php5-mcrypt','php5-intl','php5-gd','php5-dev','php5-curl','php5-common','php5-cli','php5-cgi','php-pear','build-essential','php-apc','php5-imap','unzip']


##################### AWSCLI Install #####################
 
        execute 'sawscli_install' do
                command 'curl-O https://bootstrap.pypa.io/get-pip.py'
                command 'python get-pip.py'
                command 'pip install awscli'
        end


##################### Service Restart Section ############################
#Certain services are going to need to be restarted
#And that is why this section is here.

	service 'nginx' do
		supports :status => true
		action [:enable, :start]
	end

	service 'php5-fpm' do
		supports :status => true
		action [:enable, :start]
	end


##################### FILE DELETION SECTION ##############################
#This section is used to delete the files that we need to edit.  
#The main reason for this sections is so that if we need to change
#A file we can add it here and create it further down without
#having to do go in a creating another script
#KISS BABY

		file '/etc/php5/fpm/php.ini' do
			action :delete 
			end

		file '/etc/nginx/sites-available/default' do
			action :delete
			end

		file '/etc/php5/fpm/pool.d/www.conf' do
			action :delete
			end

		file '/etc/nginx/nginx.conf' do
			action :delete
			end

		file '/etc/security/limits.conf' do
			action :delete
			end

		file '/etc/sysctl.conf' do
			action :delete
			end

################### Command Execution Section ######################

	execute 's3bucket_sync' do
		command 'aws s3 sync s3://sdchefrepo314 /tmp'
	end
	

################### File Creation Section ####################
#This section right here is for re-creating the files that we deleted
#IT IS VERY IMPORTANT, that you create what you deleted or you WILL
#Break something!!!!


		file '/usr/share/nginx/html/info.php' do
			content IO.read ('/tmp/info.php')
			action :create
			end

		file '/etc/php5/fpm/php.ini' do
			content IO.read ('/tmp/php.ini')
			action :create
			end

		file '/etc/nginx/sites-available/default' do
			content IO.read ('/tmp/default')
			action :create
			end

		file '/etc/php5/fpm/pool.d/www.conf' do
			content IO.read ('/tmp/www.conf')
			action :create
			end

		file '/etc/nginx/nginx.conf' do
			content IO.read ('/tmp/nginx.conf')
			action :create
			end

		file '/etc/security/limits.conf' do
			content IO.read ('/tmp/limits.conf')
			action :create
			end

		file '/etc/sysctl.conf' do
			content IO.read ('/tmp/sysctl.conf')
			action :create
			end


################## Service Restart Section ###################



	service 'nginx' do 
		supports :status => true
		action [:enable, :restart]
	end

	service 'php5-fpm' do
		supports :status => true
		action [:enable, :restart]
	end


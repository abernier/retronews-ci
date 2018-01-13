SELENIUM_JAR_URL = http://selenium-release.storage.googleapis.com/3.8/selenium-server-standalone-3.8.1.jar
SELENIUM_JAR = tmp/selenium-server-standalone-3.8.1.jar
SELENIUM_URL = http://localhost:4444/wd/hub

# https://github.com/lmc-eu/steward/wiki/Selenium-server-&-browser-drivers
GECKODRIVER_PATH = $(CURDIR)/bin/geckodriver
CHROMEDRIVER_PATH = $(CURDIR)/bin/chromedriver

.PHONY: test
test: $(SELENIUM_JAR) ./node_modules/.bin/tap
	# 1. Start Selenium standalone server passing browsers' paths
	# 2. Wait for Selenium to start
	# 3. Execute tests
	java \
	  -Dwebdriver.gecko.driver=$(GECKODRIVER_PATH) \
	  -Dwebdriver.chrome.driver=$(CHROMEDRIVER_PATH) \
	  -jar $(SELENIUM_JAR) & \
	until `curl $(SELENIUM_URL)/status -o /dev/null --silent`; do printf "Waiting for selenium...\r"; done && \
	./node_modules/.bin/tap test/index.js && echo "Ok" || echo "Nok"
	# 4. Kill Selenium server
	kill -9 $$(lsof -ti tcp:4444)

$(SELENIUM_JAR):
	mkdir -p $(@D)
	curl $(SELENIUM_JAR_URL) > $@

node_modules: package-lock.json
	npm install
./node_modules/%:
	npm install

.FORCE:

.PHONY: clean
clean:
	-rm -Rf $(SELENIUM_JAR) node_modules
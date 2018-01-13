SELENIUM_JAR_URL = http://selenium-release.storage.googleapis.com/3.8/selenium-server-standalone-3.8.1.jar
SELENIUM_JAR = tmp/selenium-server-standalone-3.8.1.jar
SELENIUM_URL = http://localhost:4444/wd/hub

# https://github.com/lmc-eu/steward/wiki/Selenium-server-&-browser-drivers
GECKODRIVER_PATH = $(CURDIR)/bin/geckodriver
CHROMEDRIVER_PATH = $(CURDIR)/bin/chromedriver

.PHONY: test
test: ./node_modules/.bin/tap
	java \
	  -Dwebdriver.gecko.driver=$(GECKODRIVER_PATH) \
	  -Dwebdriver.chrome.driver=$(CHROMEDRIVER_PATH) \
	  -jar $(SELENIUM_JAR) & \
	until `curl $(SELENIUM_URL)/status -o /dev/null --silent`; do \
		printf "Waiting for selenium...\r"; \
	done && \
	npm test && echo "Ok" || echo "Nok"
	kill -9 $$(lsof -ti tcp:4444)

$(SELENIUM_JAR):
	curl $(SELENIUM_JAR_URL) > $@

node_modules: package-lock.json
	npm install
./node_modules/%:
	npm install

.FORCE:

.PHONY: clean
clean:
	-rm -Rf $(SELENIUM_JAR) node_modules
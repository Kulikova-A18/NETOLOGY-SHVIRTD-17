# Домашнее задание к занятию 11 «Teamcity»

Произвела подготовку к выполнению задания, а именно запустила сервер TeamCity и агент TeamCity. Заходила вручную и вводить следующую команду:

```
docker run -d -e SERVER_URL="http://58.150.79.46:8111" jetbrains/teamcity-agent
```

Создала новый проект на основе форка репозитория, указанного в задании. Для этого я создала свой собственный репозиторий на GitHub и сделала копию предложенного репозитория.

Настроила автоматическое обнаружение конфигурации, которое успешно идентифицировало настройки Maven. Первая сборка в ветке master прошла без ошибок, и все тесты были успешно выполнены/

Затем я внесла изменения в условия сборки.

Загрузила файл settings.xml, при этом креденциалы для подключения к Nexus оставила стандартными (admin/admin123).

В файле pom.xml добавила ссылку на репозиторий Nexus и сделала пуш изменений в свой репозиторий на GitHub. После этого запустила сборку в ветке master и убедилась, что она завершилась успешно.

Далее я мигрировала конфигурацию сборки в репозиторий.

Создала отдельную ветку add_reply в репозитории на GitHub, чтобы работать над новыми изменениями.

В этой ветке я реализовала новый метод ```sayWelcomeNew()``` для класса Welcomer (https://github.com/Kulikova-A18/09-ci-05-teamcity_example-teamcity/blob/master/src/main/java/plaindoll/Welcomer.java)

```
package plaindoll;

public class Welcomer{
	public String sayWelcome() {
		return "Welcome home, good hunter. What is it your desire?";
	}
	public String sayFarewell() {
		return "Farewell, good hunter. May you find your worth in waking world.";
	}
	public String sayNeedGold(){
		return "Not enough gold";
	}
	public String saySome(){
		return "something in the way";
	}
	public String sayWelcomeNew(){
		return "Welcome NEW home. What is it your desire!!!";
	}
}
```

А также я написала тест для нового метода ``` welcomerSaysWelcomeNEW() ``` в классе Welcomer, чтобы убедиться в его корректной работе (https://github.com/Kulikova-A18/09-ci-05-teamcity_example-teamcity/blob/master/src/test/java/plaindoll/WelcomerTest.java)

```
package plaindoll;

import static org.hamcrest.CoreMatchers.containsString;
import static org.junit.Assert.*;

import org.junit.Test;

public class WelcomerTest {
	
	private Welcomer welcomer = new Welcomer();

	@Test
	public void welcomerSaysWelcome() {
		assertThat(welcomer.sayWelcome(), containsString("Welcome"));
	}
	@Test
	public void welcomerSaysFarewell() {
		assertThat(welcomer.sayFarewell(), containsString("Farewell"));
	}
	@Test
	public void welcomerSaysHunter() {
		assertThat(welcomer.sayWelcome(), containsString("hunter"));
		assertThat(welcomer.sayFarewell(), containsString("hunter"));
	}
	@Test
	public void welcomerSaysSilver(){
		assertThat(welcomer.sayNeedGold(), containsString("gold"));
	}
	@Test
	public void welcomerSaysSomething(){
		assertThat(welcomer.saySome(), containsString("something"));
	}
	@Test
	public void welcomerSaysWelcomeNEW(){
		assertThat(welcomer.sayWelcomeNEW(), containsString("NEW"));
	}
}
```

После этого сделала пуш изменений в репозиторий. Сборка была запущена автоматически, и после исправления некоторых ошибок тесты прошли успешно.

Затем я выполнила слияние ветки add_reply с веткой master, чтобы интегрировать новые изменения.

Как я понимаю, Maven автоматически собирает .jar файл в артефакты сборки. Это подтверждает успешное выполнение всех этапов процесса сборки и тестирования.

Ссылка: https://github.com/Kulikova-A18/09-ci-05-teamcity_example-teamcity/tree/master

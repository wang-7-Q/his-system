# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project shape

A Hospital Information System (HIS) teaching project split into two roots:

- `backend/` — Spring Boot 2.2.10 (Java 8) multi-module Maven project, MyBatis + MySQL.
- `front/` — HarmonyOS ArkTS V2 project (DevEco Studio), formerly Vue 2 + Element UI (已替换).

The frontend talks to the backend over HTTP via a centralized `ApiClient` singleton configured with `http://localhost:8091` (drugstore + login) and `http://localhost:8092` (outpatient, registration, physician, check, inspection, disposal).

Architecture: 5-layer — models(10) → common(4) → components(10) → services(8) → pages(35). Total 69 `.ets` files, 34 registered routes across 6 business modules.

Code comments and UI strings are in Chinese; identifiers are English.

## Backend

### Module layout

`backend/pom.xml` is the aggregator. Three child modules:

| Module | Packaging | Entry point | Port | Scope |
|---|---|---|---|---|
| `his-common` | jar | `com.neuedu.Application` (not normally run) | — | Shared MyBatis mappers, `RestBean` response wrapper, utilities. Depended on by the other two. |
| `his-drugstore` | jar (Spring Boot fat-jar) | `com.neuedu.DrugStoreApplication` | 8091 | Drug warehouse + dispensing/refund + **login endpoint** (the whole frontend logs in via 8091). |
| `his-outpatient` | jar (Spring Boot fat-jar) | `com.neuedu.OutPatientApplication` | 8092 | Registration, doctor diagnosis, examination, inspection, disposal. |

Both runnable apps point at the same MySQL database `neuhis` on `127.0.0.1:3306` (user `root` / `root`) configured in each module's `src/main/resources/application.properties`. You must start both apps in parallel for the frontend to be fully functional — the login button hits 8091 while most business pages hit 8092.

### Per-module package structure (drugstore/outpatient)

```
com.neuedu/
  XxxApplication.java        @SpringBootApplication entry
  controller/<domain>/       @RestController + @CrossOrigin, thin pass-through to service
  service/<domain>/          interface
  service/<domain>/impl/     @Service implementation
```

Mappers live only in `his-common` (`com.neuedu.mapper.*Mapper` + `src/main/resources/mapper/*Mapper.xml`). The `application.properties` sets `mybatis.mapper-locations=classpath:/mapper/*.xml`, so any new mapper XML goes in the common module to be picked up.

### Response convention

`com.neuedu.bean.RestBean` is the standard response envelope: `{ list, totalCount, msg, status }`. Most paged queries return it; some endpoints return raw `String` or `List<Map>` directly (e.g., login, `addRegister`). There's no global response wrapper or exception handler — controllers return what the service returns.

Controllers use `@RequestMapping` (no HTTP method restriction) almost everywhere, accept `@RequestParam Map<String,Object>` for form-encoded payloads, and rely on `@CrossOrigin` per-class for CORS.

### Pagination

`PageUtil.objectToInt(map)` parses `nowPageNumber` / `pageSize` from the request map into `Integer` before handing them to MyBatis. Mapper XMLs use `LIMIT ${(nowPageNumber-1) * pageSize} ,#{pageSize}` — note the `${}` interpolation for offset, which is SQL-injectable if these come from untrusted input (currently they come from the trusted frontend pagination component).

### Build / run

Maven Wrapper is not present — use a local `mvn`. From `backend/`:

```powershell
mvn -pl his-common install -am          # build & install the shared jar to local repo first
mvn -pl his-drugstore spring-boot:run   # run drugstore on :8091
mvn -pl his-outpatient spring-boot:run  # run outpatient on :8092
```

Or build fat-jars (the `spring-boot-maven-plugin` is wired with `repackage`):

```powershell
mvn -pl his-drugstore,his-outpatient -am package
java -jar his-drugstore/target/his-drugstore-0.0.1-SNAPSHOT.jar
java -jar his-outpatient/target/his-outpatient-0.0.1-SNAPSHOT.jar
```

### Tests

The parent pom sets `<skipTests>true</skipTests>` on `maven-surefire-plugin`, so `mvn test` and `mvn package` skip tests by default. Three JUnit 4 + Spring `@SpringBootTest` tests exist under `his-outpatient/src/test/java/com/neuedu/service/registration/`. To run them:

```powershell
mvn -pl his-outpatient -Dtest=DepartmentServiceTest -DskipTests=false test
mvn -pl his-outpatient -DskipTests=false test                              # all tests in outpatient
```

These tests hit the real `neuhis` MySQL database — they are not isolated.

## Frontend (`front/`)

Vue 2.6 + Element UI 2.15 + vue-router 3 + Vuex 3 + axios 0.26. Vuex store is currently empty; auth state lives in `sessionStorage` keys `Flag` (`"isLogin"`) and `loginUser` (JSON of the logged-in employee row).

### Run / build

```powershell
npm install --registry=https://registry.npmmirror.com   # mirror per README, optional
$env:NODE_OPTIONS="--openssl-legacy-provider"           # REQUIRED on Node 17+ for webpack 4
npm run serve                                            # dev server (default :8080)
npm run build                                            # production build to /dist
```

The `--openssl-legacy-provider` flag is required because the vue-cli-service 4.x uses the old OpenSSL provider; without it the dev server fails to start on modern Node.

### Router / layout architecture

`src/router/index.js` is the single source of truth for navigation. Every business page is a lazy-loaded child route under one of six top-level groups (挂号收费, 门诊医生, 检查管理, 检验管理, 药房管理, 处置管理). Each group has `meta.type` (e.g., `"门诊"`, `"药房"`).

`src/layout/index.vue` reads `this.$router.options.routes` and renders the sidebar menu, filtering by `loginUser.dept_type`:

```js
v-if="!item.hidden && (item.meta.type == dept_type || dept_type == 'root')"
```

This is the entire authorization model. A user only sees menu items whose group `meta.type` matches their department type (or everything if they're `root`). There is no server-side authorization check — any user who knows a URL can navigate to it.

`main.js` installs a global `router.beforeEach` guard that redirects based on `sessionStorage.Flag === "isLogin"` and the route's `meta.isLogin` flag.

### Adding a page

1. Create `src/views/<group>/<name>.vue`.
2. Register it as a child of the matching group in `src/router/index.js` with `meta: { isLogin: true }`.
3. Wire backend calls with hard-coded `http://localhost:8091/...` or `:8092/...` URLs matching which backend module owns the endpoint (drugstore-related → 8091; everything else → 8092).
4. Form-encoded POSTs use `qs.stringify(payload)` (see `onsite_registration.vue` for the pattern); the global axios default is set in `main.js`: `Axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded'`.

### Demo credentials

From `views/Login.vue` (visible on the login screen): username `root` / `挂号` / `扁鹊` (or other doctor name) / `检查` / `检验` / `处置`, all with password `123`. `root` can see every menu but the UI warns not to perform business operations as root.

## Things to know before editing

- **No git repo**: this directory is not under version control (`git status` will fail). Treat changes as in-place edits with no commit history to consult.
- **Login lives in drugstore**: the `/login` endpoint is in `his-drugstore`, not in `his-common` or `his-outpatient`. If only outpatient is running, the frontend can't log in.
- **Mappers belong in `his-common`**: a new mapper XML placed in a business module's `src/main/resources/mapper/` will not be loaded — `mybatis.mapper-locations=classpath:/mapper/*.xml` only matches what's on the classpath through the common jar.
- **Hard-coded logout URL**: `src/layout/index.vue` redirects to `http://39.105.101.77:8080/index.html` on logout. This is a remote demo deployment URL, not a local path — change it if running standalone.
- **Tests skipped by default**: `mvn package` / `mvn install` will not run them. Pass `-DskipTests=false` if you want them to run, and remember they hit the live database.

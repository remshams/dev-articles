//
//  ArticleContent.swift
//  dev-articles
//
//  Created by Mathias Remshardt on 03.07.21.
//

import Foundation

struct ArticleContent: Equatable {
  let html: String
}

#if DEBUG

  // swiftlint:disable all
  let exampleArticleContent = ArticleContent(html: """
  <p>In this article we will delve into the build chain and build steps necessary to create the artifacts required to publish a library on npm. Our goal will be to provide our library consumers with a versatile package supporting (modern/legacy) JavaScript/TypeScript as well as the most common module systems.<br>
  What has been written is based on my learnings and research when creating packages and is also meant to be documentation for myself. The process is still in flux, so every feedback (ideas for improvements, critics...) is, as always, very welcome.</p>
  <h1>
  <a name="overview" href="#overview" class="anchor">
  </a>
  Overview
  </h1>

  <p>The first section lists and explains the requirements for the build process as well as the artifacts it produces. Related to this, we will also answer the question if a bundled version is required for each of the supported module systems.<br><br>
  With the requirements ready, the build chain and, most important, the steps for creating the necessary library artifacts will be laid out.</p>

  <p>As demonstration defeats discussion, we will look at the implementation of the sketched out build chain with help of an example "library". In the end there will be a deployment ready package, hopefully fulfilling all listed requirements.<br><br>
  As our focus lies on packing itself, the "features" of the example library are irrelevant and are therefore kept extremely simple.</p>

  <p>The explanations provided are based on my current understanding of the topics and may be opinionated or incomplete (hopefully not wrong). In addition, every package is unique and therefor its/your requirements and the resulting process can differ from what has been written here. However, I have tried to keep the information as overall applicable as possible. As mentioned in the beginning, feed back is very welcome.<br><br>
  That being said, let's start with the requirements for our build artifacts.</p>
  <h1>
  <a name="requirements" href="#requirements" class="anchor">
  </a>
  Requirements
  </h1>
  <h2>
  <a name="javascripttypescript" href="#javascripttypescript" class="anchor">
  </a>
  JavaScript/TypeScript
  </h2>

  <p>To me, one important goal was to make the modernly written, not transpilled library code available for further processing. This helps e.g. to decrease bundle sizes, as downstream consumers can base their build chain on the most current/common JavaScript version and only transpile the code to the language level required by their browser- or node version needs.</p>

  <p>However, for consumers not able to leverage modern JavaScript, an ES5 based version sacrificing the latest features must be provided.</p>

  <p>In case TypeScript is used, a transpilled JavaScript version should be supplied as well, so we do not enforce unnecessary restrictions to consumers by our language choice. "Types" will be provided as separate type definition files.</p>
  <h2>
  <a name="module-system" href="#module-system" class="anchor">
  </a>
  Module system
  </h2>

  <p>Next to modern JavaScript, the library must support all current/common module systems. At the time of writing these are "ECMAScript Modul" (<code>esm</code>), "CommonJs" (<code>cjs</code>) and "Asynchronous Module Definition" (<code>AMD</code>).</p>

  <p>Especially supporting <code>esm</code> is important to allow tree shaking support for consumers using bundlers like Rollup or webpack. So even when transpilled to legacy JavaScript, leveraging <code>esm</code> is still beneficial (as described <a href="https://web.dev/publish-modern-javascript/#modern-with-legacy-fallback-and-esm-bundler-optimizations">here</a>).</p>
  <h1>
  <a name="to-bundle-or-not-to-bundle" href="#to-bundle-or-not-to-bundle" class="anchor">
  </a>
  To bundle or not to bundle...
  </h1>

  <p>Bundling is usually applied when writing JavaScript for the client (e.g. <code>Single Page Applications</code>) as it avoids too many round trips to the server (especially before <code>HTTP/2</code> arrived) by delivering everything in a single file. However, with multiplexing and server side push now being available in <code>HTTP/2</code>, the questions is a bit more controversial today.</p>

  <p>If we take into account that downstream build systems further process and bundle the library code, the npm package should contain an unbundled artifact for all supported module systems with the most modern JavaScript version possible. This gives our consumers the flexibility to shape the library code based on their needs (e.g. supported browser versions) helping them to reduce the amount of shipped code by avoiding e.g. unnecessary transpilling.</p>

  <p>So if the library code is further processed by downstream consumers, one may ask the question if we need to create a bundled version at all? I sifted through different (popular and not so popular) npm packages and some of these are bundling, while others are not. Also reading blog posts and tutorials did not give a unambiguous answer, leaving me more confused then before.<br><br>
  Therefor I decided to look at each module system individually combined with whether it is used on the client or server. My hope was that I'd find some enlightenment when narrowing done the question...<br>
  Next you find the reasoning I finally came up with.</p>
  <h2>
  <a name="ecmascript-modules" href="#ecmascript-modules" class="anchor">
  </a>
  ECMAScript Modules
  </h2>
  <h3>
  <a name="browser" href="#browser" class="anchor">
  </a>
  Browser
  </h3>

  <p>When <code>esm</code> based library artifacts are consumed by e.g. <code>SPAs</code> something like webpack or Rollup should be in place. Further processing, like tree-shaking, bundling, minifying..., is therefor better left to the downstream build process.</p>

  <p>So I originally decided not to include a bundled <code>esm</code> version. But, when reading about the reasoning for providing a bundled <code>umd</code> artifact (described in the section below) I thought about doing the same for <code>esm</code>. It does sound counterintuitive at first, I mean what benefit do we get from a modern module system when everything is bundled to a single file. What we do get however, is all the modern JavaScript available for library code written in ES6+ syntax. This means modern browser can choose the bundled <code>esm</code> version instead of <code>umd</code> for direct import, avoiding all the additional code created to make our library code compatible with previous JavaScript versions. One could argue that in such a case the unbundled artifact could be imported. However, there still could be use cases for the bundled alternative e.g. in case <code>HTTP/2</code> is not available and therefor loading a lots of files is not a performant option.</p>
  <h3>
  <a name="node" href="#node" class="anchor">
  </a>
  Node
  </h3>

  <p>In case the server application uses a current node version, same reasoning as for the browser applies.<br><br>
  However, the server can directly load the files from disk which should have almost no performance impact compared to the http request the browser has to perform. So I don't see any reason for using the bundled version here, even if no additional build process is in place.</p>
  <h2>
  <a name="commonjs" href="#commonjs" class="anchor">
  </a>
  CommonJs
  </h2>
  <h3>
  <a name="browser" href="#browser" class="anchor">
  </a>
  Browser
  </h3>

  <p>Same arguments as for <code>esm</code>: Bundling should not be required as the imported library is always further processed by downstream build systems.<br>
  The only reason why client applications could/should use the <code>cjs</code> instead of the <code>esm</code> version is in case of an older bundler which does not understand the latter. In all other cases <code>esm</code> is the preferred option as the tree shaking support is superior to <code>cjs</code>.</p>
  <h3>
  <a name="node" href="#node" class="anchor">
  </a>
  Node
  </h3>

  <p>Again no difference to <code>esm</code>. However, by including a <code>cjs</code> version we ensure older node versions are also supported, so no additional/extra transpilling step is required for library consumers.</p>
  <h2>
  <a name="umd" href="#umd" class="anchor">
  </a>
  UMD
  </h2>

  <p>We will discuss the bundling question for <code>umd</code> instead of <code>amd</code>, as the latter supports both <code>amd</code> and <code>cjs</code> in a single artifact.</p>
  <h3>
  <a name="browser" href="#browser" class="anchor">
  </a>
  Browser
  </h3>

  <p>For me, the bundling question was a bit harder to answer for <code>umd</code>, as I have most often worked in environments (usually <code>SPAs</code>) where either <code>cjs</code> and/or <code>esm</code> has been used in combination with a dedicated bundler.<br><br>
  The reason for including a bundled <code>umd</code> version is to support direct usage (with no further processing) in (older) browsers e.g. from something like <a href="https://unpkg.com">unpkg</a>. Modern browser, as described above, can use the bundled <code>esm</code> version.<br><br>
  However, when a bundling step is performed downstream, it should always either use <code>esm</code> or <code>cjs</code> making an unbundled version superfluous.</p>
  <h3>
  <a name="node" href="#node" class="anchor">
  </a>
  Node
  </h3>

  <p>Node can always use either <code>esm</code> or <code>cjs</code>. So in case these are included in the npm package there seems to be no reason to provide a special, unbundled <code>umd</code> version for node. It provides no benefit over the bundled variant already considered required in order to cover all use cases.</p>

  <p>My final impression regarding <code>umd</code> and server applications is, that it makes sense if one wants to include only a single version of the library. However, since npm packages and bundlers (now) support including multiple versions and creating these is not much effort, there seems to be no reason for restricting library consumers to just <code>umd</code>.</p>
  <h2>
  <a name="conclusion" href="#conclusion" class="anchor">
  </a>
  Conclusion
  </h2>

  <p>This brings us the conclusion that a bundled version is only required for <code>esm</code> and <code>umd</code>. For all other module system bundling is not a necessity, which finally leads to the following list of library artifacts:</p>

  <ul>
  <li>an unbundled <code>esm</code> version</li>
  <li>an bundled <code>esm</code> version</li>
  <li>an unbundled <code>cjs</code> version</li>
  <li>a bundled <code>umd</code> version</li>
  </ul>

  <p>These four variants should cover most of our consumers use cases without restricting their build processes and, most importantly, not forcing them to ship unnecessary JavaScript code.</p>

  <p>Having the bundle/not bundle question out of the way, we will next define the build chain and its steps to create the listed artifacts.</p>
  <h1>
  <a name="build-chain" href="#build-chain" class="anchor">
  </a>
  Build chain
  </h1>

  <p>The diagram below gives an overview of the steps required to go from our written source code (TypeScript for the example library) to the artifacts described in the previous section. The image also shows how the created results are referenced in the <code>package.json</code>. This is important as it makes downstream bundlers "aware" of the available versions allowing them to choose the most appropriate one (e.g. <code>esm</code> over <code>cjs</code> for better tree shaking support).</p>

  <p><a href="https://res.cloudinary.com/practicaldev/image/fetch/s--crgTkvZX--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/build-chain.jpeg%3Fraw%3Dtrue" class="article-body-image-wrapper"><img src="https://res.cloudinary.com/practicaldev/image/fetch/s--crgTkvZX--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/build-chain.jpeg%3Fraw%3Dtrue" alt="Build chain overview" loading="lazy"></a></p>

  <p>Diagrams often read kind of abstract before knowing the details and this one is no exception. Therefor, when next going through the process and its artifacts, excerpts from the example library (e.g. configuration files) are referenced to provide additional details.<br><br>
  One note regarding the employed build tools mentioned in the diagram: I tried to use the most common ones for this/my build chain fulfilling the requirements listed earlier. These can of course be replaced by your own choice e.g. <code>tsc</code> instead of <code>babel</code> when compiling TypeScript.</p>
  <h2>
  <a name="building-the-library-artifacts" href="#building-the-library-artifacts" class="anchor">
  </a>
  Building the library artifacts
  </h2>

  <p>The build steps next described need to get us from our source to the four target build artifacts defined in the previous section. For the example application this means going from TypeScript to <code>esm</code> (bundled and unbundled), <code>cjs</code> (unbundled) and <code>umd</code> (bundled).<br><br>
  The two main steps required are transpilling and bundling. The latter is of course only needed when the final build artifact is a bundle.</p>
  <h3>
  <a name="transpilling" href="#transpilling" class="anchor">
  </a>
  Transpilling
  </h3>

  <p>With the example application written in TypeScript, our first step is to go to the target JavaScript versions. Usually this can either be done by using <code>tsc</code> or, as of late, <code>babel</code> (with help of the <code>@babel/typescript</code> plugin).<br><br>
  I opted for the latter as it, in my opinion, provides more flexibility compared to <code>tsc</code> when configuring the transpilation/compilation step (e.g. <code>tsc</code> requires a specific target JavaScript version where as in <code>babel</code> it can be defined based on browsers market share, versions and the like). In addition, with the support of TypeScript in Babel, we can now use almost the same build chain for JavaScript or TypeScript projects helping to unify/simplify the process.</p>

  <p>The exact Babel configuration is somehow specific for each individual library/project and/or requirements. For the example library we only require two babel plugins:</p>

  <ul>
  <li>
  <a href="https://babeljs.io/docs/en/babel-preset-typescript">@babel/typescript</a>: To go from TypeScript to JavaScript</li>
  <li>
  <a href="https://babeljs.io/docs/en/babel-preset-env">@babel/env</a>: To get down to the JavaScript version fulfilling the configuration we opted for (e.g. supported browsers and node versions)</li>
  </ul>

  <p>A description of the two plugins and the available configurations is out of scope of the article. Therefor, I only quickly note why a property has been set like that and the reasoning behind it.<br><br>
  Especially the <code>@babel/env</code> plugin provides a lot of flexibility, so in case you are interested in more details the two provided links should make for a good starting point.</p>

  <p>Having that said, the configuration for the example library looks like the following:<br>
  </p>

  <div class="highlight js-code-highlight">
  <pre class="highlight javascript"><code><span class="kd">const</span> <span class="nx">sharedPresets</span> <span class="o">=</span> <span class="p">[</span><span class="dl">'</span><span class="s1">@babel/typescript</span><span class="dl">'</span><span class="p">];</span>
  <span class="kd">const</span> <span class="nx">shared</span> <span class="o">=</span> <span class="p">{</span>
  <span class="na">ignore</span><span class="p">:</span> <span class="p">[</span><span class="dl">'</span><span class="s1">src/**/*.spec.ts</span><span class="dl">'</span><span class="p">],</span>
  <span class="na">presets</span><span class="p">:</span> <span class="nx">sharedPresets</span>
  <span class="p">}</span>

  <span class="nx">module</span><span class="p">.</span><span class="nx">exports</span> <span class="o">=</span> <span class="p">{</span>
  <span class="na">env</span><span class="p">:</span> <span class="p">{</span>
  <span class="na">esmUnbundled</span><span class="p">:</span> <span class="nx">shared</span><span class="p">,</span>
  <span class="na">esmBundled</span><span class="p">:</span> <span class="p">{</span>
  <span class="p">...</span><span class="nx">shared</span><span class="p">,</span>
  <span class="na">presets</span><span class="p">:</span> <span class="p">[[</span><span class="dl">'</span><span class="s1">@babel/env</span><span class="dl">'</span><span class="p">,</span> <span class="p">{</span>
  <span class="na">targets</span><span class="p">:</span> <span class="dl">"</span><span class="s2">&gt; 0.25%, not dead</span><span class="dl">"</span>
  <span class="p">}],</span> <span class="p">...</span><span class="nx">sharedPresets</span><span class="p">],</span>
  <span class="p">},</span>
  <span class="na">cjs</span><span class="p">:</span> <span class="p">{</span>
  <span class="p">...</span><span class="nx">shared</span><span class="p">,</span>
  <span class="na">presets</span><span class="p">:</span> <span class="p">[[</span><span class="dl">'</span><span class="s1">@babel/env</span><span class="dl">'</span><span class="p">,</span> <span class="p">{</span>
  <span class="na">modules</span><span class="p">:</span> <span class="dl">'</span><span class="s1">commonjs</span><span class="dl">'</span>
  <span class="p">}],</span> <span class="p">...</span><span class="nx">sharedPresets</span><span class="p">],</span>
  <span class="p">}</span>
  <span class="p">}</span>
  <span class="p">}</span>
  </code></pre>
  <div class="highlight__panel js-actions-panel">
  <div class="highlight__panel-action js-fullscreen-code-action">
  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-on"><title>Enter fullscreen mode</title>
  <path d="M16 3h6v6h-2V5h-4V3zM2 3h6v2H4v4H2V3zm18 16v-4h2v6h-6v-2h4zM4 19h4v2H2v-6h2v4z"></path>
  </svg>

  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-off"><title>Exit fullscreen mode</title>
  <path d="M18 7h4v2h-6V3h2v4zM8 9H2V7h4V3h2v6zm10 8v4h-2v-6h6v2h-4zM8 15v6H6v-4H2v-2h6z"></path>
  </svg>

  </div>
  </div>
  </div>



  <p>We are using three Babel environments here:</p>

  <ul>
  <li>
  <code>esmUnbundled</code>: The environment only goes from TypeScript to JavaScript and keeps the rest of the code in place. This is on purpose as it makes the most modern version of the library available to our consumers for further processing.</li>
  <li>
  <code>esmBundled</code>: In addition to what is done in <code>unbundled</code>, the <code>bundled</code> environment transpiles to JavaScript supported by the majority of browsers/node versions. I opted against transpilling completely down to <code>ES2015</code> as older browser can use the <code>umd</code> alternative when directly importing the library.</li>
  <li>
  <code>cjs</code>: Again, the environment is similar to <code>es-unbundled</code>, with the only difference that <code>esm</code> is replaced by <code>commonjs</code> with the help of <code>@babel/env</code>
  </li>
  </ul>

  <p>To execute the Babel transpilation, two <code>scripts</code> have been defined in the <code>package.json</code>:<br>
  </p>

  <div class="highlight js-code-highlight">
  <pre class="highlight json"><code><span class="p">{</span><span class="w">
  </span><span class="err">...</span><span class="w">
  </span><span class="nl">"build:esm"</span><span class="p">:</span><span class="w"> </span><span class="s2">"cross-env BABEL_ENV=esmUnbundled babel src --extensions '.ts' --out-dir 'lib/esm' --source-maps"</span><span class="p">,</span><span class="w">
  </span><span class="nl">"build:cjs"</span><span class="p">:</span><span class="w"> </span><span class="s2">"cross-env BABEL_ENV=cjs babel src --extensions '.ts' --out-dir 'lib/cjs' --source-maps"</span><span class="w">
  </span><span class="err">...</span><span class="w">
  </span><span class="p">}</span><span class="w">
  </span></code></pre>
  <div class="highlight__panel js-actions-panel">
  <div class="highlight__panel-action js-fullscreen-code-action">
  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-on"><title>Enter fullscreen mode</title>
  <path d="M16 3h6v6h-2V5h-4V3zM2 3h6v2H4v4H2V3zm18 16v-4h2v6h-6v-2h4zM4 19h4v2H2v-6h2v4z"></path>
  </svg>

  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-off"><title>Exit fullscreen mode</title>
  <path d="M18 7h4v2h-6V3h2v4zM8 9H2V7h4V3h2v6zm10 8v4h-2v-6h6v2h-4zM8 15v6H6v-4H2v-2h6z"></path>
  </svg>

  </div>
  </div>
  </div>



  <p>At the time of writing, source maps <a href="https://github.com/babel/babel/issues/5261">seem not to be generated</a> when configured in <code>.babelrc</code> which is why <code>--source-maps</code> has been added.<br><br>
  Running the scripts gives the following result:</p>

  <p><a href="https://res.cloudinary.com/practicaldev/image/fetch/s--Uu_XxpzI--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/buid-unbundled.png%3Fraw%3Dtrue" class="article-body-image-wrapper"><img src="https://res.cloudinary.com/practicaldev/image/fetch/s--Uu_XxpzI--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/buid-unbundled.png%3Fraw%3Dtrue" alt="Dist folder with unbundled artifacts" loading="lazy"></a></p>

  <p>Unsurprisingly, the <code>esm</code> folder contains the unbundled <code>esm</code> and <code>cjs</code> the unbundled <code>cjs</code> artifact.</p>

  <p>For the unbundled case we are almost done. What is missing is a reference to our <code>index.js</code> entry files from to <code>package.json</code> to make Bundlers aware of the available versions.<br><br>
  As described in detail <a href="https://webpack.js.org/guides/package-exports/">here</a> we need to:</p>

  <ol>
  <li>Set the <code>main</code> property to our <code>cjs</code> <code>index.js</code> and the <code>module</code> property to the <code>esm</code> <code>index.js</code>
  </li>
  <li>Set the appropriate properties in <code>exports</code>

  <ul>
  <li>
  <code>require</code> again to the <code>cjs</code> <code>index.js</code>
  </li>
  <li>
  <code>import</code> again to the <code>esm</code> <code>index.js</code>
  </li>
  </ul>
  </li>
  </ol>
  <div class="highlight js-code-highlight">
  <pre class="highlight json"><code><span class="p">{</span><span class="w">
  </span><span class="err">....</span><span class="w">
  </span><span class="nl">"main"</span><span class="p">:</span><span class="w"> </span><span class="s2">"lib/cjs/index.js"</span><span class="p">,</span><span class="w">
  </span><span class="nl">"module"</span><span class="p">:</span><span class="w"> </span><span class="s2">"lib/esm/index.js"</span><span class="p">,</span><span class="w">
  </span><span class="nl">"exports"</span><span class="p">:</span><span class="w"> </span><span class="p">{</span><span class="w">
  </span><span class="nl">"require"</span><span class="p">:</span><span class="w"> </span><span class="s2">"./lib/cjs/index.js"</span><span class="p">,</span><span class="w">
  </span><span class="nl">"import"</span><span class="p">:</span><span class="w"> </span><span class="s2">"./lib/esm/index.js"</span><span class="w">
  </span><span class="p">}</span><span class="w">
  </span><span class="err">....</span><span class="w">
  </span><span class="p">}</span><span class="w">
  </span></code></pre>
  <div class="highlight__panel js-actions-panel">
  <div class="highlight__panel-action js-fullscreen-code-action">
  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-on"><title>Enter fullscreen mode</title>
  <path d="M16 3h6v6h-2V5h-4V3zM2 3h6v2H4v4H2V3zm18 16v-4h2v6h-6v-2h4zM4 19h4v2H2v-6h2v4z"></path>
  </svg>

  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-off"><title>Exit fullscreen mode</title>
  <path d="M18 7h4v2h-6V3h2v4zM8 9H2V7h4V3h2v6zm10 8v4h-2v-6h6v2h-4zM8 15v6H6v-4H2v-2h6z"></path>
  </svg>

  </div>
  </div>
  </div>


  <p>Having the <code>package.json</code> setup like that, Bundlers can now choose whatever alternative is best supported. For example modern ones can take the <code>esm</code> artifact whereas as older ones (not supporting the new <code>module</code> and <code>exports</code> property) fall back to what is referenced in <code>main</code>.</p>

  <p>To finalize our package we will next look how to generate the bundled artifacts for <code>esm</code> and <code>umd</code>.</p>
  <h3>
  <a name="bundling" href="#bundling" class="anchor">
  </a>
  Bundling
  </h3>

  <p>To bundle our library we need a ... Bundler. I chose Rollup for the job since it has good support for creating different versions for each module system from a single entry file. Of course it can again be replaced by whatever Bundler you prefer as long as it bundles to the required module systems and also comes with a plugin for the Transpiler, Terser... of your choice.</p>

  <p>As shown in the overview from the beginning of this section, there is not much difference between the build steps of the unbundled and bundled versions:</p>

  <ul>
  <li>the Bundler takes care of orchestrating the build process and build tools (like the Transpiler), so no need to call these "individually"</li>
  <li>an additional bundling step is added to the end of the build chain</li>
  </ul>

  <p>For the example library, the Rollup configuration looks like this:<br>
  </p>

  <div class="highlight js-code-highlight">
  <pre class="highlight javascript"><code><span class="k">import</span> <span class="nx">babel</span> <span class="k">from</span> <span class="dl">'</span><span class="s1">@rollup/plugin-babel</span><span class="dl">'</span><span class="p">;</span>
  <span class="k">import</span> <span class="nx">resolve</span> <span class="k">from</span> <span class="dl">'</span><span class="s1">@rollup/plugin-node-resolve</span><span class="dl">'</span><span class="p">;</span>
  <span class="k">import</span> <span class="p">{</span> <span class="nx">terser</span> <span class="p">}</span> <span class="k">from</span> <span class="dl">"</span><span class="s2">rollup-plugin-terser</span><span class="dl">"</span><span class="p">;</span>

  <span class="kd">const</span> <span class="nx">extensions</span> <span class="o">=</span> <span class="p">[</span><span class="dl">'</span><span class="s1">.js</span><span class="dl">'</span><span class="p">,</span> <span class="dl">'</span><span class="s1">.ts</span><span class="dl">'</span> <span class="p">];</span>

  <span class="k">export</span> <span class="k">default</span>  <span class="p">{</span>
  <span class="na">input</span><span class="p">:</span> <span class="dl">'</span><span class="s1">src/index.ts</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">output</span><span class="p">:</span> <span class="p">[</span>
  <span class="p">{</span>
  <span class="na">file</span><span class="p">:</span> <span class="dl">'</span><span class="s1">lib/bundles/bundle.esm.js</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">format</span><span class="p">:</span> <span class="dl">'</span><span class="s1">esm</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">sourcemap</span><span class="p">:</span> <span class="kc">true</span>
  <span class="p">},</span>
  <span class="p">{</span>
  <span class="na">file</span><span class="p">:</span> <span class="dl">'</span><span class="s1">lib/bundles/bundle.esm.min.js</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">format</span><span class="p">:</span> <span class="dl">'</span><span class="s1">esm</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">plugins</span><span class="p">:</span> <span class="p">[</span><span class="nx">terser</span><span class="p">()],</span>
  <span class="na">sourcemap</span><span class="p">:</span> <span class="kc">true</span>
  <span class="p">},</span>
  <span class="p">{</span>
  <span class="na">file</span><span class="p">:</span> <span class="dl">'</span><span class="s1">lib/bundles/bundle.umd.js</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">format</span><span class="p">:</span> <span class="dl">'</span><span class="s1">umd</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">name</span><span class="p">:</span> <span class="dl">'</span><span class="s1">myLibrary</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">sourcemap</span><span class="p">:</span> <span class="kc">true</span>
  <span class="p">},</span>
  <span class="p">{</span>
  <span class="na">file</span><span class="p">:</span> <span class="dl">'</span><span class="s1">lib/bundles/bundle.umd.min.js</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">format</span><span class="p">:</span> <span class="dl">'</span><span class="s1">umd</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">name</span><span class="p">:</span> <span class="dl">'</span><span class="s1">myLibrary</span><span class="dl">'</span><span class="p">,</span>
  <span class="na">plugins</span><span class="p">:</span> <span class="p">[</span><span class="nx">terser</span><span class="p">()],</span>
  <span class="na">sourcemap</span><span class="p">:</span> <span class="kc">true</span>
  <span class="p">}</span>
  <span class="p">],</span>
  <span class="na">plugins</span><span class="p">:</span> <span class="p">[</span>
  <span class="nx">resolve</span><span class="p">({</span> <span class="nx">extensions</span> <span class="p">}),</span>
  <span class="nx">babel</span><span class="p">({</span> <span class="na">babelHelpers</span><span class="p">:</span> <span class="dl">'</span><span class="s1">bundled</span><span class="dl">'</span><span class="p">,</span> <span class="na">include</span><span class="p">:</span> <span class="p">[</span><span class="dl">'</span><span class="s1">src/**/*.ts</span><span class="dl">'</span><span class="p">],</span> <span class="nx">extensions</span><span class="p">,</span> <span class="na">exclude</span><span class="p">:</span> <span class="dl">'</span><span class="s1">./node_modules/**</span><span class="dl">'</span><span class="p">})</span>
  <span class="p">]</span>
  <span class="p">}</span>
  </code></pre>
  <div class="highlight__panel js-actions-panel">
  <div class="highlight__panel-action js-fullscreen-code-action">
  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-on"><title>Enter fullscreen mode</title>
  <path d="M16 3h6v6h-2V5h-4V3zM2 3h6v2H4v4H2V3zm18 16v-4h2v6h-6v-2h4zM4 19h4v2H2v-6h2v4z"></path>
  </svg>

  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-off"><title>Exit fullscreen mode</title>
  <path d="M18 7h4v2h-6V3h2v4zM8 9H2V7h4V3h2v6zm10 8v4h-2v-6h6v2h-4zM8 15v6H6v-4H2v-2h6z"></path>
  </svg>

  </div>
  </div>
  </div>



  <p>There is nothing too fancy going on:<br><br>
  The <code>input</code> property points to the entry <code>index.ts</code> and <code>output</code> defines the configurations for both <code>esm</code> (normal/minified) and <code>umd</code>(normal/minified). Additionally, the <code>sourcemap</code> attribute has been added and set to <code>true</code> to create external source map files. The <code>name</code> property for the <code>umd</code> version defines the namespace for the exported functions (e.g. <code>myLibrary.echo()</code> for the example library).<br><br>
  For the build itself we require three plugins:</p>

  <ul>
  <li>
  <code>@rollup/plugin-node-resolve</code>: The plugin adds support to resolve imports to other node packages. This is not required for the example library (as no other dependency is used) but has been added since it is not unlikely to occur for more complex packages.</li>
  <li>
  <code>@rollup/plugin-babel</code>: Triggers the transpile step through Babel (basically what we have done by means of the <code>babel-cli</code> for the unbundled versions). As we are using babel only for the bundled artifacts <code>babelHelpers</code> are set to <code>bundled</code>, so in case any helpers are needed these are added to the bundle file (you can read more about the property in the <a href="https://github.com/rollup/plugins/tree/master/packages/babel#babelhelpers">documentation</a>). In <code>include</code> and <code>extensions</code> the files and their extensions (<code>ts/js</code> for the example library) to process are defined, whereas<code>excludes</code> indicates folders/patterns which should be skipped (just the <code>node_modules</code> folder for the example library).</li>
  <li>
  <code>rollup-plugin-terser</code>: Used for minification and therefor only added for the minified outputs. This is optional and can be left out in case not wanted or required.</li>
  </ul>

  <p>Executing the Rollup process by using the added <code>package.json</code> script <code>build:bundles</code> produces the following result:</p>

  <p><a href="https://res.cloudinary.com/practicaldev/image/fetch/s--s-7WSeBH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/build-bundled.png%3Fraw%3Dtrue" class="article-body-image-wrapper"><img src="https://res.cloudinary.com/practicaldev/image/fetch/s--s-7WSeBH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/build-bundled.png%3Fraw%3Dtrue" alt="Dist folder with bundled artifacts" loading="lazy"></a></p>

  <p>An new folder <code>bundles</code> has been created containing the <code>esm</code> and <code>umd</code> artifacts. In contrast to the unbundled ones, there is no need/means to reference the former from the <code>package.json</code> as these will be directly imported and are not meant for further processing.</p>

  <p>We now have all required "code" artifacts available for the package. The last thing missing is creating type definitions, so that clients using TypeScript can easily integrate the library.</p>
  <h2>
  <a name="types" href="#types" class="anchor">
  </a>
  Types
  </h2>

  <p>Babel currently "only" transpiles our TypeScript code to JavaScript. Therefor, as shown in the overview diagram, a dedicated build step is required for creating the type definition files using <code>tsc</code>.</p>

  <p>As we already have the transpiled JavaScript code, our <code>tsconfig.json</code> can be kept pretty simple:<br>
  </p>

  <div class="highlight js-code-highlight">
  <pre class="highlight json"><code><span class="p">{</span><span class="w">
  </span><span class="nl">"compilerOptions"</span><span class="p">:</span><span class="w"> </span><span class="p">{</span><span class="w">
  </span><span class="nl">"declaration"</span><span class="p">:</span><span class="w"> </span><span class="kc">true</span><span class="p">,</span><span class="w">
  </span><span class="nl">"emitDeclarationOnly"</span><span class="p">:</span><span class="w"> </span><span class="kc">true</span><span class="p">,</span><span class="w">
  </span><span class="nl">"declarationMap"</span><span class="p">:</span><span class="w"> </span><span class="kc">true</span><span class="p">,</span><span class="w">
  </span><span class="nl">"outDir"</span><span class="p">:</span><span class="w"> </span><span class="s2">"lib/types"</span><span class="p">,</span><span class="w">
  </span><span class="p">},</span><span class="w">
  </span><span class="nl">"include"</span><span class="p">:</span><span class="w"> </span><span class="p">[</span><span class="w">
  </span><span class="s2">"./src/index.ts"</span><span class="w">
  </span><span class="p">],</span><span class="w">
  </span><span class="p">}</span><span class="w">
  </span></code></pre>
  <div class="highlight__panel js-actions-panel">
  <div class="highlight__panel-action js-fullscreen-code-action">
  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-on"><title>Enter fullscreen mode</title>
  <path d="M16 3h6v6h-2V5h-4V3zM2 3h6v2H4v4H2V3zm18 16v-4h2v6h-6v-2h4zM4 19h4v2H2v-6h2v4z"></path>
  </svg>

  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-off"><title>Exit fullscreen mode</title>
  <path d="M18 7h4v2h-6V3h2v4zM8 9H2V7h4V3h2v6zm10 8v4h-2v-6h6v2h-4zM8 15v6H6v-4H2v-2h6z"></path>
  </svg>

  </div>
  </div>
  </div>



  <p>With the <code>declarations</code> and <code>emitDeclarationOnly</code> set to <code>true</code>, <code>tsc</code> only creates declarations files and skips transpilling to JavaScript. The result is then put into the folder defined by <code>outDir</code>.<br><br>
  We also should not miss to create mappings between the <code>*.d.ts</code> and <code>*.ts</code> files, enabling IDEs like VSCode or IntelliJ to navigate directly to the source instead of the declarations files e.g. on <code>CMD + click</code>/<code>Strg + click</code> on a method or property name. This is simply done by adding the <code>declarationMap</code> to the <code>tsconfig.json</code> and setting it again to <code>true</code>.</p>

  <p>The script <code>declarations</code> has been added to the <code>package.json</code> to trigger <code>tsc</code>, which will create the declaration files in the <code>types</code> folder (as defined by <code>outDir</code>):</p>

  <p><a href="https://res.cloudinary.com/practicaldev/image/fetch/s--qhwGsiMV--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/build-types.png%3Fraw%3Dtrue" class="article-body-image-wrapper"><img src="https://res.cloudinary.com/practicaldev/image/fetch/s--qhwGsiMV--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/build-types.png%3Fraw%3Dtrue" alt="Dist folder with TypeScript types" loading="lazy"></a></p>

  <p>As a final step we link the <code>index.d.ts</code> file in the <code>package.json</code> by means of the <code>types</code> property, helping IDEs to discover the types:<br>
  </p>

  <div class="highlight js-code-highlight">
  <pre class="highlight json"><code><span class="p">{</span><span class="w">
  </span><span class="nl">"types"</span><span class="p">:</span><span class="w"> </span><span class="s2">"lib/types/index.d.ts"</span><span class="w">
  </span><span class="p">}</span><span class="w">
  </span></code></pre>
  <div class="highlight__panel js-actions-panel">
  <div class="highlight__panel-action js-fullscreen-code-action">
  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-on"><title>Enter fullscreen mode</title>
  <path d="M16 3h6v6h-2V5h-4V3zM2 3h6v2H4v4H2V3zm18 16v-4h2v6h-6v-2h4zM4 19h4v2H2v-6h2v4z"></path>
  </svg>

  <svg xmlns="http://www.w3.org/2000/svg" width="20px" height="20px" viewbox="0 0 24 24" class="highlight-action crayons-icon highlight-action--fullscreen-off"><title>Exit fullscreen mode</title>
  <path d="M18 7h4v2h-6V3h2v4zM8 9H2V7h4V3h2v6zm10 8v4h-2v-6h6v2h-4zM8 15v6H6v-4H2v-2h6z"></path>
  </svg>

  </div>
  </div>
  </div>



  <p>With the unbundled-, bundled library versions and type declarations created, we now have a library ready for being published on npm. Since there are numerous posts out there explaining this final step (and the example application is pretty useless) we will not go further into this.<br><br>
  So time for wrapping up...</p>

  <h1>
  <a name="conclusion" href="#conclusion" class="anchor">
  </a>
  Conclusion
  </h1>

  <p>The goal for this article was to create a versatile build chain to allow creating libraries that:</p>

  <ul>
  <li>provide raw, non transpilled artifacts based on modern JavaScript or TypeScript which can be further processed by downstream build chains</li>
  <li>provide an unbundled- (for consumers using Bundlers) and bundled (for direct usage/import) version</li>
  <li>support all modern and legacy module systems</li>
  </ul>

  <p>With the listed requirements ready, we sketched the build steps and setup necessary to create our library artifacts.<br><br>
  To make the theoretical overview more tangible the process has been described based on a simple example library. This included a possible choice of tools required to realize the build chain and creating the artifacts necessary to fulfill our initial goals.</p>

  <h1>
  <a name="appendix" href="#appendix" class="anchor">
  </a>
  Appendix
  </h1>

  <h2>
  <a name="testing-locally" href="#testing-locally" class="anchor">
  </a>
  Testing locally
  </h2>

  <p>To test the example library locally I have created a separate <a href="https://github.com/remshams/node-module-esm-test">"testing repository"</a>. The setup and link procedure is as follows:</p>

  <ul>
  <li>
  <a href="https://github.com/remshams/node-module-esm">Example Library</a>

  <ul>
  <li>Run <code>npm install</code>
  </li>
  <li>Run <code>npm build</code>
  </li>
  </ul>


  </li>
  <li>

  <p><a href="https://github.com/remshams/node-module-esm-test">Testing Repo</a></p>

  <ul>
  <li>Use <code>npm link</code> to link to the locally available example library e.g. in case both projects are siblings in the folder structure the command is <code>npm link ../node-module-esm</code> (a more detailed description can be found e.g. <a href="https://medium.com/dailyjs/how-to-use-npm-link-7375b6219557">here</a>)</li>
  <li>Run <code>npm install</code>
  </li>
  <li>Run <code>npm start</code> (this starts a local http-server)</li>
  <li>Open <code>localhost:8080</code> in the browser of your choice</li>
  <li>Navigate to <code>src</code>
  </li>
  <li>The then opened <code>index.html</code> includes imports of <code>umd bundled</code>, <code>esm bundled</code> and <code>esm unbundled</code> from the example library giving the following result:</li>
  </ul>

  <p><a href="https://res.cloudinary.com/practicaldev/image/fetch/s--zWwQAx04--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/testing-index.png%3Fraw%3Dtrue" class="article-body-image-wrapper"><img src="https://res.cloudinary.com/practicaldev/image/fetch/s--zWwQAx04--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/remshams/node-module-esm/blob/images/images/testing-index.png%3Fraw%3Dtrue" alt="Screenshot testing index.html" loading="lazy"></a></p>


  </li>
  </ul>
  """)
#endif

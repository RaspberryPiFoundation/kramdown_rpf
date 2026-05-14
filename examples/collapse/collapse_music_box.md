--- collapse ---
---
title: Creating Directories on a Raspberry Pi
---
<h2 id="creating-directories-on-a-raspberry-pi">Creating Directories on a Raspberry Pi</h2>

<p>There are two ways to create directories on the Raspberry Pi. The first uses the GUI, and the second uses the Terminal.</p>

<h3 id="method-1---using-the-gui">Method 1 - Using the GUI</h3>

<p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/GUI-make-directory.gif" alt="GUI-make-directory" /></p>

<ol>
  <li>
    <p>Open a File Manager window by clicking on the icon in the top left corner of the screen</p>

    <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/file-manager.png" alt="file-manager" /></p>
  </li>
  <li>In the window, right-click and select <em>Create New…</em> and then <em>Folder</em> from the context menu</li>
  <li>In the dialogue box, type the name of your new directory and then click <em>OK</em></li>
</ol>

<h3 id="method-2---using-the-terminal">Method 2 - Using the Terminal</h3>

<p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/Terminal-make-directory.gif" alt="Terminal-make-directory" /></p>

<ol>
  <li>
    <p>Open a new Terminal window by clicking on the icon in the top left corner of the screen.</p>

    <p><img src="https://s3.eu-west-2.amazonaws.com/learning-resources-dev-staging/projects/rpi-gui-creating-directories/1524b3cda91ceced8b88abbb72f7746a58176311/en/images/terminal.png" alt="terminal" /></p>
  </li>
  <li>
    <p>You can create a new directory using the <code>mkdir</code> command</p>

    <div class="language-bash highlighter-coderay"><div class="CodeRay">
  <div class="code"><pre> mkdir my-new-directory
</pre></div>
</div>
    </div>
  </li>
  <li>You can list the contents of the current directory using <code>ls</code></li>
  <li>
    <p>To enter your new directory use the <code>cd</code> command</p>

    <div class="language-bash highlighter-coderay"><div class="CodeRay">
  <div class="code"><pre> cd my-new-directory
</pre></div>
</div>
    </div>
  </li>
</ol>


--- /collapse ---
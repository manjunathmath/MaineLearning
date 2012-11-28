<?php
/*
 * IMPORTANT - PLEASE READ **************************************************************************
 * All the mechanics to control this plugin are automatically generated from the extension name.	*
 * You do not need to modify this page, unless you wish to add additional customisable parameters	*
 * for the extension. Removing/changing any of the pre defined functions will cause import errors,	*
 * and possible other unexpected or unwanted behaviour.												*
 * **************************************************************************************************
 */

/*
 * '$extension' controls content on this page and is set to whatever admin-settings.php file is being viewed.
 * i.e. if you extension name is 'my_extension', the value of $extension will be 'my_extension'.
 *  Make sure the extension name is in lower case.
 */
$extension = bebop_extensions::bebop_get_extension_config_by_name( strtolower( $extension ) );


//Include the admin menu.
include_once( WP_PLUGIN_DIR . '/bebop/core/templates/admin/bebop-admin-menu.php' ); ?>
<div id='bebop_admin_container'>
	<div class='postbox center_margin margin-bottom_22px'>
		<h3><?php echo sprintf( __( '%1$s Settings', 'bebop' ), $extension['display_name'] ); ?></h3>
		<div class="inside">
			<p><?php echo sprintf( __( 'Settings for the %1$s extension.', 'bebop' ), $extension['display_name'] ); ?></p>
			<p><?php _e( 'To pull content from some providers, the importer settings need to be configured correctly for some extensions. For example, "API Tokens", and "API secrets" may be required for API based sources, but not for RSS based sources.', 'bebop') ?></p>
			<p><?php _e( 'By default, RSS feeds are available for each extension in Bebop, and are automaticlly generated when an extension is active. You can turn the rss feeds off by simply unchecking the "enabled" option of the RSS feed settings below. Please note
				that RSS feeds will only be available when the extension is active.', 'bebop') ?></p>
			<p><?php _e( 'As of version 1.2, you can choose whether content needs to be verified for each extension. This will allow you more control over how content is imported into your BuddyPress activity streams.', 'bebop' ); ?></p>
			<p><?php _e( 'As of version 1.2, You can choose whether you wish to hide content for the extension on the sitewide activity steam. All content is still visible in members activity streams, and in the resources stream.', 'bebop' ); ?></p>
		</div>
	</div>
	<form class='bebop_admin_form' method='post'>
		<fieldset>  
			<span class='header'><?php echo sprintf( __( '%1$s Import Settings', 'bebop' ), $extension['display_name'] ); ?></span>
			
			<?php $should_users_verify_content = bebop_tables::get_option_value( 'bebop_' . $extension['name'] . '_content_user_verification' ); ?>
			<label for='bebop_<?php echo $extension['name']; ?>_content_user_verification'><?php _e( 'Should imported content be user verified?', 'bebop' ); ?></label>
			<select id='bebop_<?php echo $extension['name']; ?>_content_user_verification' name='bebop_<?php echo $extension['name']; ?>_content_user_verification'>
				<option value='yes'<?php if ( $should_users_verify_content === 'yes' ) { echo 'SELECTED'; } ?>><?php _e( 'Yes', 'bebop' ); ?></option>
				<option value='no'<?php if ( $should_users_verify_content === 'no' ) { echo 'SELECTED'; } ?>><?php _e( 'No', 'bebop' ); ?></option>
			</select>
			<br><br>
			
			<?php $bebop_hide_sitewide = bebop_tables::get_option_value( 'bebop_' . $extension['name'] . '_hide_sitewide' ); ?>
			<label for='bebop_<?php echo $extension['name']; ?>_hide_sitewide'><?php _e( 'Hide content on the sitewide activity stream?', 'bebop' ); ?></label>
			<select id='bebop_<?php echo $extension['name']; ?>_hide_sitewide' name='bebop_<?php echo $extension['name']; ?>_hide_sitewide'>
				<option value='no'<?php if ( $bebop_hide_sitewide === 'no' ) { echo 'SELECTED'; } ?>><?php _e( 'No', 'bebop' ); ?></option>
				<option value='yes'<?php if ( $bebop_hide_sitewide === 'yes' ) { echo 'SELECTED'; } ?>><?php _e( 'Yes', 'bebop' ); ?></option>
			</select>
			<br><br>
			
			<label for='bebop_<?php echo $extension['name']; ?>_maximport'><?php _e( 'Imports per day (blank = unlimited)', 'bebop') ?>:</label>
			<input type='text' id='bebop_<?php echo $extension['name']; ?>_maximport' name='bebop_<?php echo $extension['name']; ?>_maximport' value='<?php echo bebop_tables::get_option_value( 'bebop_' . $extension['name'] . '_maximport' ); ?>' size='5'>
		</fieldset>
		
		<fieldset>
			<span class='header'><?php echo sprintf( __( '%1$s RSS Settings', 'bebop' ), $extension['display_name'] ); ?></span>
			<?php
			if ( bebop_tables::get_option_value( 'bebop_' . $extension['name'] . '_provider' ) == 'on' ) {
				echo "<label for='bebop_" . $extension['name'] . "_rss_feed'>" . __( 'RSS Enabled', 'bebop' ) . ":</label><input id='bebop_" .$extension['name'] . "_rss_feed' name='bebop_".$extension['name'] . "_rss_feed' type='checkbox'";
				if ( bebop_tables::get_option_value( 'bebop_' . $extension['name'] . '_rss_feed' ) == 'on' ) {
					echo 'CHECKED';
				}
				echo '>';
			}
			else {
				echo '<p>' . sprintf( __( 'RSS feeds cannot be enabled because %1$s is not an active extension.', 'bebop' ), $extension['display_name'] ) . '</p>';
			}
			?>
		</fieldset>
		
		<?php wp_nonce_field( 'bebop_' . $extension['name'] . '_admin_settings' ); ?>
		
		<input class='button-primary' type='submit' id='submit' name='submit' value='<?php _e( 'Save Changes', 'bebop' ); ?>'>
		
	</form>
	<?php
	
	//slightly different for this count because we have many feeds and no usernames.
	$user_metas = bebop_tables::get_user_ids_from_meta_name( 'bebop_' . $extension['name'] . '_active_for_user' );
	if ( count( $user_metas ) > 0 ) {
		?>
		<table class="widefat margin-top_22px margin-bottom_22px">
			<thead>
				<tr>
					<th colspan='5'><?php echo sprintf( __( '%1$s Users', 'bebop' ), $extension['display_name'] ); ?></th>
				</tr>
				<tr>
					<td class='bold'><?php _e( 'User ID', 'bebop' ); ?></td>
					<td class='bold'><?php _e( 'Username', 'bebop' ); ?></td>
					<td class='bold'><?php _e( 'User email', 'bebop' ); ?></td>
					<td class='bold'><?php _e( 'Options', 'bebop' ); ?></td>
				</tr>
			</thead>
			<?php if ( count( $user_metas ) >= 10 ) { ?>
			<tfoot>
				<tr>
					<td class='bold'><?php _e( 'User ID', 'bebop' ); ?></td>
					<td class='bold'><?php _e( 'Username', 'bebop' ); ?></td>
					<td class='bold'><?php _e( 'User email', 'bebop' ); ?></td>
					<td class='bold'><?php _e( 'Options', 'bebop' ); ?></td>
				</tr>
			</tfoot>
			<?php } ?>
			<tbody>
				<?php
				/*
				 * Loops through each user and prints their details to the screen.
				 */
				foreach ( $user_metas as $user ) {
					$this_user = get_userdata( $user->user_id );
					echo '<tr>
						<td>' . bebop_tables::sanitise_element( $user->user_id ) . '</td>
						<td>' . bebop_tables::sanitise_element( $this_user->user_login ) . '</td>
						<td>' . bebop_tables::sanitise_element( $this_user->user_email ) . "</td>
						<td><a href='?page=bebop_providers&provider=" . $extension['name'] . "&reset_user_id=" . bebop_tables::sanitise_element( $user->user_id ) . "'>" . __( 'Reset User', 'bebop' ) . "</a></td>
					</tr>";
				}
			?>
			<!-- <End bebop_table -->
			</tbody>
		</table>
		<?php
	}
	else {
		echo sprintf( __( 'No users found for the %1$s extension.', 'bebop' ), $extension['display_name'] );
	}
	?>
<!-- End bebop_admin_container -->
</div>